class AdminController < ApplicationController
require 'csv'


    def admindashboard

    end


private
    def user_params
      params.require(:user).permit(:username, :role, :password, :permission, :view_as, :first, :last, :email, :degree_id, :course_load, :in_class, :online, :path_id, :deleted)
    end
end