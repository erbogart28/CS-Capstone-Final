class DegreeReqsController < ApplicationController
  before_action :set_degree_req, only: [:show, :edit, :update, :destroy]

  # GET /degree_reqs
  # GET /degree_reqs.json
  def index
    @degree_reqs = DegreeReq.all
  end

  # GET /degree_reqs/1
  # GET /degree_reqs/1.json
  def show
  end

  # GET /degree_reqs/new
  def new
    @degree_req = DegreeReq.new
  end

  # GET /degree_reqs/1/edit
  def edit
  end

  # POST /degree_reqs
  # POST /degree_reqs.json
  def create
    @degree_req = DegreeReq.new(degree_req_params)

    respond_to do |format|
      if @degree_req.save
        format.html { redirect_to @degree_req, notice: 'Degree req was successfully created.' }
        format.json { render :show, status: :created, location: @degree_req }
      else
        format.html { render :new }
        format.json { render json: @degree_req.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /degree_reqs/1
  # PATCH/PUT /degree_reqs/1.json
  def update
    respond_to do |format|
      if @degree_req.update(degree_req_params)
        format.html { redirect_to @degree_req, notice: 'Degree req was successfully updated.' }
        format.json { render :show, status: :ok, location: @degree_req }
      else
        format.html { render :edit }
        format.json { render json: @degree_req.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /degree_reqs/1
  # DELETE /degree_reqs/1.json
  def destroy
    @degree_req.destroy
    respond_to do |format|
      format.html { redirect_to degree_reqs_url, notice: 'Degree req was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_degree_req
      @degree_req = DegreeReq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def degree_req_params
      params.require(:degree_req).permit(:course_id)
    end
end
