from urllib.request import urlopen
from bs4 import BeautifulSoup
from website.scraper import ThreadPool, season_map, Course, CSCurriculumKey as CS, ISCurriculumKey as IS
import csv
import re

prereq_pattern = re.compile("PREREQUISITE")
new_line_pattern = re.compile(r"[\r\n\:\|]")

ping_count = 0
course_url = "http://www.cdm.depaul.edu/academics/pages/courseinfo.aspx?Subject={}&CatalogNbr={}"
cs_curriculum_url = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-in-Computer-Science.aspx"
is_curriculum_url_bsa = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-IS-Business-Systems-Analysis.aspx"
is_curriculum_url_bi = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-IS-Business-Intelligence.aspx"
is_curriculum_url_da = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-IS-Database-Administration.aspx"
is_curriculum_url_em = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-IS-IT-Enterprise-Management.aspx"
is_curriculum_url_s = "http://www.cdm.depaul.edu/academics/Pages/Current/Requirements-MS-IS-Standard.aspx"

cs_curriculum = {
    CS.INTRODUCTORY: [],
    CS.FOUNDATION: [],
    CS.AREAS: {
        CS.SOFTWARE_AND_SYSTEMS_DEVELOPMENT: [],
        CS.THEORY: [],
        CS.DATA_SCIENCE: [],
        CS.DATABASE_SYSTEMS: [],
        CS.ARTIFICIAL_INTELLIGENCE: [],
        CS.SOFTWARE_ENGINEERING: [],
        CS.MULTIMEDIA: []
    },
    CS.RESEARCH_AND_THESIS_OPTIONS: {
        CS.RESEARCH_COLLOQUIUM: [],
        CS.MASTERS_RESEARCH: [],
        CS.MASTERS_THESIS: [],
        CS.GRADUATE_INTERNSHIP: []
    }
}

is_curriculum_seed = {
    IS.INTRODUCTORY: [],
    IS.FOUNDATION: [],
    IS.ADVANCED: [],
    IS.MAJOR_ELECTIVES: [],
    IS.CAPSTONE: []
}


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


def cs_curriculum_scraper(html_string):
    soup = BeautifulSoup(html_string, 'html.parser')
    course_list_soup = soup.select('.courseList')
    push_name_tuples(course_list_soup, 0, CS.INTRODUCTORY)
    push_name_tuples(course_list_soup, 1, CS.FOUNDATION)
    push_name_tuples(course_list_soup, 2, CS.AREAS, CS.SOFTWARE_AND_SYSTEMS_DEVELOPMENT)
    push_name_tuples(course_list_soup, 3, CS.AREAS, CS.THEORY)
    push_name_tuples(course_list_soup, 4, CS.AREAS, CS.DATA_SCIENCE)
    push_name_tuples(course_list_soup, 5, CS.AREAS, CS.DATABASE_SYSTEMS)
    push_name_tuples(course_list_soup, 6, CS.AREAS, CS.ARTIFICIAL_INTELLIGENCE)
    push_name_tuples(course_list_soup, 7, CS.AREAS, CS.SOFTWARE_ENGINEERING)
    push_name_tuples(course_list_soup, 8, CS.AREAS, CS.MULTIMEDIA)
    push_name_tuples(course_list_soup, 9, CS.RESEARCH_AND_THESIS_OPTIONS, CS.RESEARCH_COLLOQUIUM)
    push_name_tuples(course_list_soup, 10, CS.RESEARCH_AND_THESIS_OPTIONS, CS.MASTERS_RESEARCH)
    push_name_tuples(course_list_soup, 11, CS.RESEARCH_AND_THESIS_OPTIONS, CS.MASTERS_THESIS)
    push_name_tuples(course_list_soup, 12, CS.RESEARCH_AND_THESIS_OPTIONS, CS.GRADUATE_INTERNSHIP)


def is_curriculum_scraper(html_string, is_curriculum):
    soup = BeautifulSoup(html_string, 'html.parser')
    course_list_soup = soup.select('.courseList')
    concentration = soup.select('#programPageConcentration')[0].text[:-14]
    index = 0
    if concentration == "Business Intelligence" or concentration == "Database Administration":
        push_name_tuples(course_list_soup, index, IS.INTRODUCTORY, curric=is_curriculum)
        index += 1
    push_name_tuples(course_list_soup, index, IS.FOUNDATION, curric=is_curriculum)
    index += 1
    if concentration != "Standard":
        push_name_tuples(course_list_soup, index, IS.ADVANCED, curric=is_curriculum)
        index += 1
    if concentration != "Standard":
        push_name_tuples(course_list_soup, index, IS.MAJOR_ELECTIVES, curric=is_curriculum)
        index += 1
    push_name_tuples(course_list_soup, index, IS.CAPSTONE, curric=is_curriculum)


def push_name_tuples(course_list_soup, index, key, secondary_key=None, curric = cs_curriculum):
    course_soup = course_list_soup[index].select('.CDMExtendedCourseInfo')
    name_list = [Course(*td.text.strip().split()) for td in course_soup if not td.text.startswith("GAM 490")]
    if secondary_key:
        curric[key][secondary_key].extend(name_list)
    else:
        curric[key].extend(name_list)


def course_gen(curr):
    t = type(curr)
    if t == type([]):
        for v in curr:
            yield v
    elif t == type({}):
        for v in curr.values():
            for i in course_gen(v):
                yield i


def scrape_course_detail(curric):
    global course_url
    t = ThreadPool(40)
    course_html_list = []
    for course in course_gen(curric):
        url = course_url.format(course.subject, course.num)
        t.add_task(push_html, url, course, course_html_list)
    t.wait_completion()
    for course, course_html in course_html_list:
        parse_and_update_course(course, course_html)


def parse_and_update_course(course_obj, course_html):
    soup = BeautifulSoup(course_html, 'html.parser')
    title_div = soup.select('.CDMPageTitle')[0]
    course_obj.name = title_div.text.split(":\r\n    ")[1]
    course_obj.description = re.sub(new_line_pattern , ' ',title_div.findNext('div').text.strip())
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


def write_to_csv(curric, name):
    with open(name, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=':', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for course in course_gen(curric):
            writer.writerow(["{} {}".format(course.subject, course.num),
                             course.name,
                             course.description,
                             course.prerequisites if course.prerequisites is not None else "",
                             ",".join(entry for entry in course.history)])


if __name__ == '__main__':
    html_string = pull_html(cs_curriculum_url)
    cs_curriculum_scraper(html_string)
    scrape_course_detail(cs_curriculum)
    write_to_csv(cs_curriculum, 'cs.csv')

    curr = is_curriculum_seed.copy()
    html_string = pull_html(is_curriculum_url_bsa)
    is_curriculum_scraper(html_string, curr)
    scrape_course_detail(curr)
    write_to_csv(curr, 'is_bsa.csv')

    curr = is_curriculum_seed.copy()
    html_string = pull_html(is_curriculum_url_bi)
    is_curriculum_scraper(html_string, curr)
    scrape_course_detail(curr)
    write_to_csv(curr, 'is_bi.csv')

    curr = is_curriculum_seed.copy()
    html_string = pull_html(is_curriculum_url_da)
    is_curriculum_scraper(html_string, curr)
    scrape_course_detail(curr)
    write_to_csv(curr, 'is_da.csv')

    curr = is_curriculum_seed.copy()
    html_string = pull_html(is_curriculum_url_em)
    is_curriculum_scraper(html_string, curr)
    scrape_course_detail(curr)
    write_to_csv(curr, 'is_em.csv')

    curr = is_curriculum_seed.copy()
    html_string = pull_html(is_curriculum_url_s)
    is_curriculum_scraper(html_string, curr)
    scrape_course_detail(curr)
    write_to_csv(curr, 'is_s.csv')

    print(*("{} : {}".format(i, j) for i, j in cs_curriculum.items()), sep='\n')
