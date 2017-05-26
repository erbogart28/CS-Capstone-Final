class BrowseCoursesController < ApplicationController
  before_action :set_browse_course, only: [:show, :edit, :update, :destroy]

  # GET /browse_courses
  # GET /browse_courses.json
  def index
    @browse_course = if params[:term]
    Course.where('name LIKE ?', "%#{params[:term]}%")
  else
    @browse_courses = Course.all
  end
  end

  # GET /browse_courses/1
  # GET /browse_courses/1.json
  def show
  end

  # GET /browse_courses/new
  def new
    @browse_course = Course.new
  end

  # GET /browse_courses/1/edit
  def edit
  end

  # POST /browse_courses
  # POST /browse_courses.json
  def create
    @browse_course = Course.new(browse_course_params)

    respond_to do |format|
      if @browse_course.save
        format.html { redirect_to @browse_course, notice: 'Browse course was successfully created.' }
        format.json { render :show, status: :created, location: @browse_course }
      else
        format.html { render :new }
        format.json { render json: @browse_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /browse_courses/1
  # PATCH/PUT /browse_courses/1.json
  def update
    respond_to do |format|
      if @browse_course.update(browse_course_params)
        format.html { redirect_to @browse_course, notice: 'Browse course was successfully updated.' }
        format.json { render :show, status: :ok, location: @browse_course }
      else
        format.html { render :edit }
        format.json { render json: @browse_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /browse_courses/1
  # DELETE /browse_courses/1.json
  def destroy
    @browse_course.destroy
    respond_to do |format|
      format.html { redirect_to browse_courses_url, notice: 'Browse course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_browse_course
      @browse_course = Course.find(params[:id])
      @browse_course_prereq = Course.joins("INNER JOIN Prereqs ON Courses.id = Prereqs.prereq_course_id").where("Prereqs.course_id = ?", @browse_course.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def browse_course_params
      params.require(:course).permit(:course_code, :name, :description, :term, :prereqs)
    end
end
