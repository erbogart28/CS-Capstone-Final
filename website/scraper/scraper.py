from urllib.request import urlopen
from bs4 import BeautifulSoup
from website.scraper import ThreadPool, season_map, Course, CurriculumKey as c
import csv
import re

prereq_pattern = re.compile("PREREQUISITE")

ping_count = 0
course_url = "http://www.cdm.depaul.edu/academics/pages/courseinfo.aspx?Subject={}&CatalogNbr={}"
curriculum_url = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-in-Computer-Science.aspx"

curriculum = {
    c.INTRODUCTORY: [],
    c.FOUNDATION: [],
    c.AREAS: {
        c.SOFTWARE_AND_SYSTEMS_DEVELOPMENT: [],
        c.THEORY: [],
        c.DATA_SCIENCE: [],
        c.DATABASE_SYSTEMS: [],
        c.ARTIFICIAL_INTELLIGENCE: [],
        c.SOFTWARE_ENGINEERING: [],
        c.MULTIMEDIA: []
    },
    c.RESEARCH_AND_THESIS_OPTIONS: {
        c.RESEARCH_COLLOQUIUM: [],
        c.MASTERS_RESEARCH: [],
        c.MASTERS_THESIS: [],
        c.GRADUATE_INTERNSHIP: []
    }
}
curriculum_detail = {}


def pull_html(url):
    global ping_count
    with urlopen(url) as response:
        encoded_html = response.read()
        html = encoded_html.decode()
        ping_count += 1
        print(ping_count)
        return html


def push_html(url, course, destination):
    global ping_count
    with urlopen(url) as response:
        encoded_html = response.read()
        html = encoded_html.decode()
        ping_count += 1
        print(ping_count)
        destination.append((course, html,))


def curriculum_scraper(html_string):
    soup = BeautifulSoup(html_string, 'html.parser')
    course_list_soup = soup.select('.courseList')
    push_name_tuples(course_list_soup, 0, c.INTRODUCTORY)
    push_name_tuples(course_list_soup, 1, c.FOUNDATION)
    push_name_tuples(course_list_soup, 2, c.AREAS, c.SOFTWARE_AND_SYSTEMS_DEVELOPMENT)
    push_name_tuples(course_list_soup, 3, c.AREAS, c.THEORY)
    push_name_tuples(course_list_soup, 4, c.AREAS, c.DATA_SCIENCE)
    push_name_tuples(course_list_soup, 5, c.AREAS, c.DATABASE_SYSTEMS)
    push_name_tuples(course_list_soup, 6, c.AREAS, c.ARTIFICIAL_INTELLIGENCE)
    push_name_tuples(course_list_soup, 7, c.AREAS, c.SOFTWARE_ENGINEERING)
    push_name_tuples(course_list_soup, 8, c.AREAS, c.MULTIMEDIA)
    push_name_tuples(course_list_soup, 9, c.RESEARCH_AND_THESIS_OPTIONS, c.RESEARCH_COLLOQUIUM)
    push_name_tuples(course_list_soup, 10, c.RESEARCH_AND_THESIS_OPTIONS, c.MASTERS_RESEARCH)
    push_name_tuples(course_list_soup, 11, c.RESEARCH_AND_THESIS_OPTIONS, c.MASTERS_THESIS)
    push_name_tuples(course_list_soup, 12, c.RESEARCH_AND_THESIS_OPTIONS, c.GRADUATE_INTERNSHIP)


def push_name_tuples(course_list_soup, index, key, secondary_key=None):
    global curriculum
    course_soup = course_list_soup[index].select('.CDMExtendedCourseInfo')
    name_list = [Course(*td.text.strip().split()) for td in course_soup if not td.text.startswith("GAM 490")]
    if secondary_key:
        curriculum[key][secondary_key].extend(name_list)
    else:
        curriculum[key].extend(name_list)


def course_gen(curr):
    t = type(curr)
    if t == type([]):
        for v in curr:
            yield v
    elif t == type({}):
        for v in curr.values():
            for i in course_gen(v):
                yield i


def scrape_course_detail():
    global curriculum, course_url
    t = ThreadPool(40)
    course_html_list = []
    for course in course_gen(curriculum):
        url = course_url.format(course.subject, course.num)
        t.add_task(push_html, url, course, course_html_list)
    t.wait_completion()
    for course, course_html in course_html_list:
        parse_and_update_course(course, course_html)


def parse_and_update_course(course_obj, course_html):
    soup = BeautifulSoup(course_html, 'html.parser')
    course_obj.name = soup.select('.CDMPageTitle')[0].text.split(":\r\n    ")[1]
    course_obj.history = [season_map[offering.text.strip()]
                          for offering in soup.select('.CTIPageSectionHeader')
                          if offering.text.strip() in season_map]
    string = soup.find(string=prereq_pattern)
    if string:
        parts = string.split("PREREQUISITE(S): ")
    else:
        return
    prereqs = parts[1].strip().strip('.') if len(parts) > 1 and parts[1] != "None" else None
    course_obj.prerequisites = prereqs


def write_to_csv():
    with open('courses.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=':', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for course in course_gen(curriculum):
            writer.writerow(["{} {}".format(course.subject, course.num),
                             course.prerequisites if course.prerequisites is not None else "",
                             ",".join(entry for entry in course.history)])


if __name__ == '__main__':
    html_string = pull_html(curriculum_url)
    curriculum_scraper(html_string)
    scrape_course_detail()
    write_to_csv()
    print(*("{} : {}".format(i, j) for i, j in curriculum.items()), sep='\n')
