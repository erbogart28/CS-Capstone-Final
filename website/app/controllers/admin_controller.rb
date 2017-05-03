class AdminController < ApplicationController
before_action :logged_in_user, only: [:index, :edit, :update] #ensure user is logged in before editing is allowed
before_action :correct_user,   only: [:edit, :update] #ensure correct user is editing correct profile
#PERMISSIONS CAN BE ADDED THROUGH CALLING METHODS LIKE THIS - BEFORE PAGE LOAD VERIFIY USER TYPE

    def admindashboard
        unless current_user.admin?
            store_location
            flash[:danger] = "Acess Denied"
            redirect_to root_path
        end
    end
end
