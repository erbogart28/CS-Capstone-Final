class CourseFrequenciesController < ApplicationController
  before_action :set_course_frequency, only: [:show, :edit, :update, :destroy]

  # GET /course_frequencies
  # GET /course_frequencies.json
  def index
    @course_frequencies = CourseFrequency.all
  end

  # GET /course_frequencies/1
  # GET /course_frequencies/1.json
  def show
  end

  # GET /course_frequencies/new
  def new
    @course_frequency = CourseFrequency.new
  end

  # GET /course_frequencies/1/edit
  def edit
  end

  # POST /course_frequencies
  # POST /course_frequencies.json
  def create
    @course_frequency = CourseFrequency.new(course_frequency_params)

    respond_to do |format|
      if @course_frequency.save
        format.html { redirect_to @course_frequency, notice: 'Course frequency was successfully created.' }
        format.json { render :show, status: :created, location: @course_frequency }
      else
        format.html { render :new }
        format.json { render json: @course_frequency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_frequencies/1
  # PATCH/PUT /course_frequencies/1.json
  def update
    respond_to do |format|
      if @course_frequency.update(course_frequency_params)
        format.html { redirect_to @course_frequency, notice: 'Course frequency was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_frequency }
      else
        format.html { render :edit }
        format.json { render json: @course_frequency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_frequencies/1
  # DELETE /course_frequencies/1.json
  def destroy
    @course_frequency.destroy
    respond_to do |format|
      format.html { redirect_to course_frequencies_url, notice: 'Course frequency was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_frequency
      @course_frequency = CourseFrequency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_frequency_params
      params.require(:course_frequency).permit(:frequency)
    end
end
