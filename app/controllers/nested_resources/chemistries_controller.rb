class NestedResources::ChemistriesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @chemistries = Chemistry.where(analysis_id: params[:analysis_id])
    respond_with @chemistries
  end

  def update
    @chemistry = Chemistry.find(params[:id])
    @chemistry.analysis_id = params[:analysis_id].to_i
    @chemistry.save
    respond_with @chemistry
  end

  def destroy
    @chemistry = Chemistry.find(params[:id])
    @chemistry.destroy
    respond_with @chemistry
  end

end
