class DocumentsController < ApplicationController
  include ImageService
  
  before_filter :load_labels

  def index
    @label = Label.find_by(id: params[:label_id])
    @documents = @label ? @label.documents : Document.unclassed
  end

  def inbox
    @label = "Inbox"
    @documents = Document.recent
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to document_path(@document.id)
    else
      render :new
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    if @document.update(document_params)
      redirect_to document_path(@document.id)
    else
      render :new
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path
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

  def load_labels
    @labels = Label.all
  end

  def document_params
    params.require(:document).permit(:title, :file, :label_id)
  end
end
