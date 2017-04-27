class CourseDeliveriesController < ApplicationController
  before_action :set_course_delivery, only: [:show, :edit, :update, :destroy]

  # GET /course_deliveries
  # GET /course_deliveries.json
  def index
    @course_deliveries = CourseDelivery.all
  end

  # GET /course_deliveries/1
  # GET /course_deliveries/1.json
  def show
  end

  # GET /course_deliveries/new
  def new
    @course_delivery = CourseDelivery.new
  end

  # GET /course_deliveries/1/edit
  def edit
  end

  # POST /course_deliveries
  # POST /course_deliveries.json
  def create
    @course_delivery = CourseDelivery.new(course_delivery_params)

    respond_to do |format|
      if @course_delivery.save
        format.html { redirect_to @course_delivery, notice: 'Course delivery was successfully created.' }
        format.json { render :show, status: :created, location: @course_delivery }
      else
        format.html { render :new }
        format.json { render json: @course_delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_deliveries/1
  # PATCH/PUT /course_deliveries/1.json
  def update
    respond_to do |format|
      if @course_delivery.update(course_delivery_params)
        format.html { redirect_to @course_delivery, notice: 'Course delivery was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_delivery }
      else
        format.html { render :edit }
        format.json { render json: @course_delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_deliveries/1
  # DELETE /course_deliveries/1.json
  def destroy
    @course_delivery.destroy
    respond_to do |format|
      format.html { redirect_to course_deliveries_url, notice: 'Course delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_delivery
      @course_delivery = CourseDelivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_delivery_params
      params.require(:course_delivery).permit(:course_id, :course_term, :course_frequency)
    end
end
