require "csv"
require "set"

class PullCoursesController < ApplicationController
    
    def create 
        ActiveRecord::Base.connection.execute("DELETE FROM COURSES")
        ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'COURSES'")
        courses_seen = Set.new()
        s = __parse_course_csv("scraper/cs.csv", courses_seen)
        s = __parse_course_csv("scraper/is_bi.csv", courses_seen)
        s = __parse_course_csv("scraper/is_bsa.csv", courses_seen)
        s = __parse_course_csv("scraper/is_da.csv", courses_seen)
        s = __parse_course_csv("scraper/is_em.csv", courses_seen)
        s = __parse_course_csv("scraper/is_s.csv", courses_seen)
        render html: s.html_safe
    end

    def __parse_course_csv(fname, seen)
        s = ""
        CSV.foreach fname, col_sep: ':' do |row|
            c = Course.new(course_code: row[0], name: row[1], description: row[2], prereqs: row[3], course_history: row[4])
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