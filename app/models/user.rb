class User < ActiveRecord::Base

  has_many :labels
  has_many :documents

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_labels

  # Events (Disabled until good training sample)
  #on :document_updated, :train_classifier_with_document
  #on :label_deleted, :delete_label_from_classifier

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

  def train_classifier_with_document(document)
    if document.label_id_changed? || document.text_changed?

      category_to_untrain = document.label_id_changed? ? Label.find_by_id(document.label_id_was).try(:to_sym) : document.label.to_sym
      text_to_untrain = document.text_changed? ? document.text_was : document.text
      classifier.untrain category_to_untrain, text_to_untrain if category_to_untrain && text_to_untrain
      
      category_to_train = document.label.try(:to_sym)
      text_to_train = document.text
      classifier.train category_to_train, text_to_train if category_to_train && text_to_train

      save!
    end
  end

  def delete_label_from_classifier(label)
    classifier.delete_category label.to_sym
    save!
  end

  serialize :classifier, Paperless::Classifier

  private

  def create_labels
    DEFAULT_LABELS.each do |label_name|
      labels.create! name: label_name
    end
  end
end
