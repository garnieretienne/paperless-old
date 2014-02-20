class PagesController < ApplicationController

  def snapshot
    document = Document.find params[:document_id]
    page = document.pages.find params[:page_id]
    serve_image page.snapshot.url, page.created_at, page.cache_key
  end

  def thumb
    document = Document.find params[:document_id]
    page = document.pages.find params[:page_id]
    serve_image page.snapshot.thumb.url, page.created_at, page.cache_key
  end

  private

  # Add HTTP Headers (Cache Control, Last-Modified, Etag)
  def serve_image(path, created_at, etag)
    if stale? last_modified: created_at.utc, etag: etag
      expires_in 1.year, public: false
      send_file path, inline: true
    end
  end
end
