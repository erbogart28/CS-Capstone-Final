class SessionsController < ApplicationController
layout 'login'

  def new
  end
  
  def create #CODE SHOULD BE ADDED TO DEFINE USER ROLES AND REDIRECT BASED ON ROLES | DO HERE OR IN HELPER
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or user
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
