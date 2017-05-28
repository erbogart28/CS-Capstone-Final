class StudentController < ApplicationController
    def studentdashboard
      @user = current_user
      @courses_taken = Course.joins("INNER JOIN completed_courses ON courses.id = completed_courses.course_id").where("completed_courses.user_id = ?",params[:id])
      @waive_course = CompletedCourse.new
    end
end
