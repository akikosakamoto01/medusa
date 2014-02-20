class NestedResources::AttachmentFilesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :find_resource
  load_and_authorize_resource

  def index
    @attachment_files = @parent.attachment_files
    respond_with @attachment_files
  end

  def create
    @attachment_file = AttachmentFile.new(attachment_file_params)
    @parent.attachment_files << @attachment_file
    @parent.save
    respond_with @attachment_file
  end

  def destroy
    @attachment_file = AttachmentFile.find(params[:id])
    @parent.attachment_files.delete(@attachment_file)
    respond_with @attachment_file
  end

  private

  def find_resource
    resource_name = params[:parent_resource]
    resource_class = resource_name.camelize.constantize
    @parent = resource_class.find(params["#{resource_name}_id"])
  end

  def attachment_file_params
    params.require(:attachment_file).permit(
      :name,
      :description,
      :md5hash,
      :data,
      :original_geometry,
      :affine_matrix
    )
  end

end