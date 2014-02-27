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
    @document = Document.new_from_file(document_params)
    save_document = @document.save

    respond_to do |format|
      format.html { save_document ? redirect_to(document_path(@document.id)) : render(:new) }
      format.js do
        @redirect_to = inbox_documents_path
        render "shared/redirect"
      end
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    update_document = @document.update(document_params)

    respond_to do |format|
      format.html { update_document ? redirect_to(document_path(@document.id)) : render(:new) }
      format.js { render "shared/reload"}
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

  # Support for `FormData` hash if a `document` key is not found
  def document_params
    if params.fetch(:document, false)
      params.require(:document).permit(:title, :file, :label_id)
    else
      params.permit(:file)
    end
  end
end
