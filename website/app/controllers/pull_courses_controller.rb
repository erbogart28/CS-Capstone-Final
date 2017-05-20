require "csv"

class PullCoursesController < ApplicationController
    
    def create 
        ActiveRecord::Base.connection.execute("DELETE FROM COURSES")
        ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'COURSES'")
        s = ""
        CSV.foreach "scraper/courses.csv", col_sep: ':' do |row|
            c = Course.new(course_code: row[0], name: row[1])
            c.save
            puts c.inspect
            s << '<div>' << c.name << '</div>'
        end
        
        s.gsub!(/\[/, '<div>') 
        s.gsub!(/(\]\\n)/, '</div>')
        render html: s.html_safe
    end
end