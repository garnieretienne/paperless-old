class User < ActiveRecord::Base
  has_many :labels
  has_many :documents

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_labels

  serialize :classifier, Paperless::Classifier.new 

  DEFAULT_LABELS = [
    "Insurance", 
    "Vehicle", 
    "Bank", 
    "Family",
    "Housing",
    "Taxes",
    "Work",
    "Healthcare",
    "Invoices and Warranty"
  ]

  def notify(message, object)
    case message
    when :document_updated
      document = object
      if document.label_id_changed? || document.text_changed?
        classifier.train document.label.name, document.text if document.label && document.text
        save!
      end
    end
  end

  private

  def create_labels
    DEFAULT_LABELS.each do |label_name|
      labels.create! name: label_name
    end
  end
end
