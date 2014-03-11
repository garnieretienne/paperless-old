class User < ActiveRecord::Base
  include Notify

  has_many :labels
  has_many :documents

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_labels

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
      classifier.untrain category_to_untrain, text_to_untrain
      
      category_to_train = document.label.try(:to_sym)
      text_to_train = document.text
      train_classifier category_to_train, text_to_train
    end
  end

  serialize :classifier, Paperless::Classifier.new 

  private
  
  def train_classifier(category, text)
    if category && text
      classifier.train category.to_sym, text
      save!
    end
  end
  
  def untrain_classifier(category, text)
    if category && text
      classifier.untrain category.to_sym, text
      save!
    end
  end

  def create_labels
    DEFAULT_LABELS.each do |label_name|
      labels.create! name: label_name
    end
  end
end
