class FacultyController < ApplicationController
before_action :logged_in_user, only: [:index, :edit, :update] #ensure user is logged in before editing is allowed
before_action :correct_user,   only: [:edit, :update] #ensure correct user is editing correct profile
#PERMISSIONS CAN BE ADDED THROUGH CALLING METHODS LIKE THIS - BEFORE PAGE LOAD VERIFIY USER TYPE

    def facultydashboard
      unless current_user.admin? || current_user.faculty?
          store_location
          flash[:danger] = "Acess Denied"
          redirect_to student_studentdashboard_path
      end
      @users = User.all
    end
    
    def studentview
      unless current_user.admin? || current_user.faculty?
          store_location
          flash[:danger] = "Acess Denied"
          redirect_to student_studentdashboard_path
      end
      @user = User.find(params[:id])
      @courses_taken = Course.joins("INNER JOIN completed_courses ON courses.id = completed_courses.course_id").where("completed_courses.user_id = ?",params[:id])
      @waive_course = CompletedCourse.new
    end
end
