class DocumentsController < ApplicationController
  include ImageService

  def index
    @documents = Document.order(created_at: :desc)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to documents_path
    else
      render :new
    end
  end

  def show
    @document = Document.find(params[:id])
    @pages = @document.pages.order(:number)
  end

  def download
    document = Document.find(params[:document_id])
    send_file document.file.url, filename: document.to_filename
  end

  def thumb
    document = Document.find params[:document_id]
    serve_image document.thumb.url, document.created_at, document.cache_key
  end

  private

  def document_params
    params.require(:document).permit(:title, :file)
  end
end
