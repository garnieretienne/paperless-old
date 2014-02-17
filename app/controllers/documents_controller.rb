class DocumentsController < ApplicationController

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
  end

  def download
    document = Document.find(params[:document_id])
    send_file document.file.url, filename: document.to_filename
  end

  private

  def document_params
    params.require(:document).permit(:title, :file)
  end
end
