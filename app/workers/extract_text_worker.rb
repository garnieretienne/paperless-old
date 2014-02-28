class ExtractTextWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)
    document.extract_text
    document.save!
  end
end