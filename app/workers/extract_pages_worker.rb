class ExtractPagesWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)
    document.extract_pages
    document.save!
  end
end