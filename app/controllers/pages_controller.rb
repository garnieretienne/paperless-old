class PagesController < ApplicationController

  def snapshot
    document = Document.find params[:document_id]
    page = document.pages.find params[:page_id]
    send_file page.snapshot.url, inline: true
  end
end
