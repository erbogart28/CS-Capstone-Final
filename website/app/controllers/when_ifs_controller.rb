class WhenIfsController < ApplicationController
  before_action :set_when_if, only: [:show, :edit, :update, :destroy]

  # GET /when_ifs
  # GET /when_ifs.json
  def index
  end

  def run
  end

  # GET /when_ifs/1
  # GET /when_ifs/1.json
  def show
  end

  # GET /when_ifs/new
  def new
  end

  # GET /when_ifs/1/edit
  def edit
  end

  # POST /when_ifs
  # POST /when_ifs.json
  def create
  end

  # PATCH/PUT /when_ifs/1
  # PATCH/PUT /when_ifs/1.json
  def update
  end

  # DELETE /when_ifs/1
  # DELETE /when_ifs/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_when_if
      @when_if = WhenIf.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def when_if_params
      params.fetch(:when_if, {})
    end
end
