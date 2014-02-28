class PagesController < ApplicationController
  include ImageService

  def snapshot
    document = current_user.documents.find params[:document_id]
    page = document.pages.find params[:page_id]
    serve_image page.snapshot.url, page.created_at, page.cache_key
  end

  def thumb
    document = current_user.documents.find params[:document_id]
    page = document.pages.find params[:page_id]
    serve_image page.snapshot.thumb.url, page.created_at, page.cache_key
  end
end
