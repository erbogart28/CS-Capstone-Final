class SessionsController < ApplicationController
layout 'login'

  def new
  end
  
  def create #CODE SHOULD BE ADDED TO DEFINE USER ROLES AND REDIRECT BASED ON ROLES | DO HERE OR IN HELPER
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) && user.admin?
      log_in user
      redirect_back_or admin_admindashboard_path
    elsif user && user.authenticate(params[:session][:password]) && user.faculty?
      log_in user
      redirect_back_or faculty_facultydashboard_path
    elsif user && user.authenticate(params[:session][:password]) && user.student?
      log_in user
      redirect_back_or student_studentdashboard_path
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
