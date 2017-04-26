class PathCoursesController < ApplicationController
  before_action :set_path_course, only: [:show, :edit, :update, :destroy]

  # GET /path_courses
  # GET /path_courses.json
  def index
    @path_courses = PathCourse.all
  end

  # GET /path_courses/1
  # GET /path_courses/1.json
  def show
  end

  # GET /path_courses/new
  def new
    @path_course = PathCourse.new
  end

  # GET /path_courses/1/edit
  def edit
  end

  # POST /path_courses
  # POST /path_courses.json
  def create
    @path_course = PathCourse.new(path_course_params)

    respond_to do |format|
      if @path_course.save
        format.html { redirect_to @path_course, notice: 'Path course was successfully created.' }
        format.json { render :show, status: :created, location: @path_course }
      else
        format.html { render :new }
        format.json { render json: @path_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /path_courses/1
  # PATCH/PUT /path_courses/1.json
  def update
    respond_to do |format|
      if @path_course.update(path_course_params)
        format.html { redirect_to @path_course, notice: 'Path course was successfully updated.' }
        format.json { render :show, status: :ok, location: @path_course }
      else
        format.html { render :edit }
        format.json { render json: @path_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /path_courses/1
  # DELETE /path_courses/1.json
  def destroy
    @path_course.destroy
    respond_to do |format|
      format.html { redirect_to path_courses_url, notice: 'Path course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_path_course
      @path_course = PathCourse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def path_course_params
      params.require(:path_course).permit(:path_id, :course_id, :year, :course_term)
    end
end
