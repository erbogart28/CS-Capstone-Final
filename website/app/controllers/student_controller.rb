class StudentController < ApplicationController
    def studentdashboard
      @courses_taken = Course.joins("INNER JOIN completed_courses ON courses.id = completed_courses.course_id").where("completed_courses.user_id = ?",current_user)
      @user = current_user
      # @when_if = WhenIf.find(params[:id])
    end
end
