require "csv"
require "set"

class PullCoursesController < ApplicationController
    
    def create 
        ActiveRecord::Base.connection.execute("DELETE FROM COURSES")
        ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'COURSES'")
        ActiveRecord::Base.connection.execute("DELETE FROM DEGREES")
        ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'DEGREES'")
        ActiveRecord::Base.connection.execute("DELETE FROM DEGREE_REQS")
        ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'DEGREE_REQS'")
        courses_seen = Set.new
        cs = [
            Degree.new(major: 'CS', concentration: 'Software and Systems Development'),
            Degree.new(major: 'CS', concentration: 'Theory'),
            Degree.new(major: 'CS', concentration: 'Data Science'),
            Degree.new(major: 'CS', concentration: 'Database Systems'),
            Degree.new(major: 'CS', concentration: 'Artificial Intelligence'),
            Degree.new(major: 'CS', concentration: 'Software Engineering'),
            Degree.new(major: 'CS', concentration: 'Multimedia')
        ]
        cs.each(&:save)
        is_bsa = Degree.new(major: 'IS', concentration: 'Business Analysis/Systems Analysis')
        is_bi = Degree.new(major: 'IS', concentration: 'Business Intelligence')
        is_da = Degree.new(major: 'IS', concentration: 'Database Administration')
        is_em = Degree.new(major: 'IS', concentration: 'IT Enterprise Management')
        is_s = Degree.new(major: 'IS', concentration: 'Standard')

        is_bsa.save
        is_bi.save
        is_da.save
        is_em.save
        is_s.save

        __parse_course_csv("scraper/cs.csv", courses_seen, cs)
        __parse_course_csv("scraper/is_bi.csv", courses_seen, is_bi)
        __parse_course_csv("scraper/is_bsa.csv", courses_seen, is_bsa)
        __parse_course_csv("scraper/is_da.csv", courses_seen, is_da)
        __parse_course_csv("scraper/is_em.csv", courses_seen, is_em)
        __parse_course_csv("scraper/is_s.csv", courses_seen, is_s)
        flash[:success] = "Courses updated"
        redirect_to admin_admindashboard_path

    end

    def __parse_course_csv(fname, seen, degree)
        s = ''
        CSV.foreach fname, col_sep: ':' do |row|
            c = Course.new(
                course_code: row[0],
                name: row[1],
                description: row[2],
                prereqs: row[3],
                course_history: row[4]
            )
            if degree.kind_of?(Array)
                degree.each do |deg|
                    DegreeReq.new(
                        course_code: row[0],
                        priority: row[5],
                        degree_id: deg.id,
                        history: row[4]
                    ).save
                end
            else
                DegreeReq.new(
                    course_code: row[0],
                    priority: row[5],
                    degree_id: degree.id,
                    history: row[4]
                ).save
            end

            unless seen.include?(c.course_code)
                seen.add(c.course_code)
                c.save
                puts c.inspect
                s << '<div>' << c.name << '</div>'
            end
        end

        s.gsub!(/\[/, '<div>')
        s.gsub!(/(\]\\n)/, '</div>')
        return s
    end
end