class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]
before_action :logged_in_user, only: [:index, :edit, :update] #ensure user is logged in before editing is allowed
before_action :correct_user,   only: [:edit, :update] #ensure correct user is editing correct profile
#PERMISSIONS CAN BE ADDED THROUGH CALLING METHODS LIKE THIS - BEFORE PAGE LOAD VERIFIY USER TYPE

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end


  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
    render :layout => "login"
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new', layout: "layouts/login"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
=begin
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
      # Handle a successful update.
     else
      render 'edit'
    end
=end

      if @user.update(user_params)
        flash[:success] = "User was successfully updated."
        redirect_to @user
      else
        render :edit
      end
#    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, success: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :permission, :view_as, :first, :last, :email, :degree_id, :course_load, :in_class, :online, :path_id, :deleted)
    end

  # Confirms non logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url
    end
  end
  
  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end#ne