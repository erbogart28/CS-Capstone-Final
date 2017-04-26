class CourseTermsController < ApplicationController
  before_action :set_course_term, only: [:show, :edit, :update, :destroy]

  # GET /course_terms
  # GET /course_terms.json
  def index
    @course_terms = CourseTerm.all
  end

  # GET /course_terms/1
  # GET /course_terms/1.json
  def show
  end

  # GET /course_terms/new
  def new
    @course_term = CourseTerm.new
  end

  # GET /course_terms/1/edit
  def edit
  end

  # POST /course_terms
  # POST /course_terms.json
  def create
    @course_term = CourseTerm.new(course_term_params)

    respond_to do |format|
      if @course_term.save
        format.html { redirect_to @course_term, notice: 'Course term was successfully created.' }
        format.json { render :show, status: :created, location: @course_term }
      else
        format.html { render :new }
        format.json { render json: @course_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_terms/1
  # PATCH/PUT /course_terms/1.json
  def update
    respond_to do |format|
      if @course_term.update(course_term_params)
        format.html { redirect_to @course_term, notice: 'Course term was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_term }
      else
        format.html { render :edit }
        format.json { render json: @course_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_terms/1
  # DELETE /course_terms/1.json
  def destroy
    @course_term.destroy
    respond_to do |format|
      format.html { redirect_to course_terms_url, notice: 'Course term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_term
      @course_term = CourseTerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_term_params
      params.require(:course_term).permit(:term)
    end
end
