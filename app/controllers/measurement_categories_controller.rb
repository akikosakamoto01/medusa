class MeasurementCategoriesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :find_resource, only: [:show, :edit, :duplicate, :update, :destroy]
  load_and_authorize_resource
  layout "admin"

  def index
    @search = MeasurementCategory.search(params[:q])
    @search.sorts = "updated_at ASC" if @search.sorts.empty?
    @measurement_categories = @search.result.page(params[:page]).per(params[:per_page])
    respond_with @measurement_categories
  end

  def show
    respond_with @measurement_category
  end

  def edit
    @units = Unit.all
    respond_with @measurement_category
  end

  def create
    @measurement_category = MeasurementCategory.new(measurement_category_params)
    @measurement_category.save
    respond_with @measurement_category
  end

  def duplicate
    @units = Unit.all
    measurement_category_orgin = @measurement_category
    @measurement_category = measurement_category_orgin.dup
    @measurement_category.name += " duplicate"
    if @measurement_category.save
      measurement_category_orgin.measurement_items.each do |measurement_item|
        @measurement_category.measurement_items << measurement_item
      end
      respond_with @measurement_category do |format|
        format.html {render :edit}
      end
    else
      redirect_to measurement_categories_path, flash: { error: "name has already been taken" }
    end
  end

  def update
    @measurement_category.update_attributes(measurement_category_params)
    @units = Unit.all
    respond_with(@measurement_category, location: measurement_categories_path)
  end

  def destroy
    @measurement_category.destroy
    respond_with @measurement_category
  end

  private

  def measurement_category_params
    params.require(:measurement_category).permit(
      :name,
      :description,
      :unit_id,
      category_measurement_items_attributes: [
        :id,
        :unit_id,
        :scale,
        :position
      ]
    )
  end

  def find_resource
    @measurement_category = MeasurementCategory.find(params[:id])
  end

end
