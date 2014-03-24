class DocumentsController < ApplicationController
  include ImageService

  def index
    @label = "Inbox"
    @documents = current_user.documents.all
  end

  def create
    @document = current_user.documents.new_from_file(document_params)
    save_document = @document.save

    respond_to do |format|
      format.html { save_document ? redirect_to(document_path(@document.id)) : render(:new) }
      format.js { @documents = current_user.documents.recent }
    end
  end

  def show
    @document = current_user.documents.find(params[:id])
    @pages = @document.pages.order(:number)
  end

  def edit
    @document = current_user.documents.find(params[:id])
  end

  def update
    @document = current_user.documents.find(params[:id])
    @document.update(document_params) ? redirect_to(document_path(@document.id)) : render(:edit)
  end

  def destroy
    @document = current_user.documents.find(params[:id])
    @document.destroy
    redirect_to documents_path
  end

  # AJAX - Refresh the document list
  def update_in_inbox
    document = current_user.documents.find(params[:document_id])
    update_document = document.update(document_params)
    @documents = current_user.documents.recent

    respond_to{|format| format.js}
  end

  # AJAX - Display a document summary
  def display_summary
    @document = current_user.documents.find(params[:document_id])
    respond_to{|format| format.js}
  end

  # Download the document
  def download
    document = current_user.documents.find(params[:document_id])
    send_file document.file.url, filename: document.to_filename
  end

  # Display the document thumb
  def thumb
    document = current_user.documents.find params[:document_id]
    serve_image document.thumb.url, document.created_at, document.cache_key
  end

  private

  # Support for `FormData` hash if a `document` key is not found
  def document_params
    if params.fetch(:document, false)
      params.require(:document).permit(:title, :file, :label_id)
    else
      params.permit(:file)
    end
  end
end
