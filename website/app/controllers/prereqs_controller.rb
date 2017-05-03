class PrereqsController < ApplicationController
  before_action :set_prereq, only: [:show, :edit, :update, :destroy]

  # GET /prereqs
  # GET /prereqs.json
  def index
    @prereqs = Prereq.all
  end

  # GET /prereqs/1
  # GET /prereqs/1.json
  def show
  end

  # GET /prereqs/new
  def new
    @prereq = Prereq.new
  end

  # GET /prereqs/1/edit
  def edit
  end

  # POST /prereqs
  # POST /prereqs.json
  def create
    @prereq = Prereq.new(prereq_params)

    respond_to do |format|
      if @prereq.save
        format.html { redirect_to @prereq, notice: 'Prereq was successfully created.' }
        format.json { render :show, status: :created, location: @prereq }
      else
        format.html { render :new }
        format.json { render json: @prereq.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prereqs/1
  # PATCH/PUT /prereqs/1.json
  def update
    respond_to do |format|
      if @prereq.update(prereq_params)
        format.html { redirect_to @prereq, notice: 'Prereq was successfully updated.' }
        format.json { render :show, status: :ok, location: @prereq }
      else
        format.html { render :edit }
        format.json { render json: @prereq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prereqs/1
  # DELETE /prereqs/1.json
  def destroy
    @prereq.destroy
    respond_to do |format|
      format.html { redirect_to prereqs_url, notice: 'Prereq was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prereq
      @prereq = Prereq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prereq_params
      params.require(:prereq).permit(:course_id, :prereq_course_id)
    end
end
