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

  private

  def create_labels
    DEFAULT_LABELS.each do |label_name|
      labels.create! name: label_name
    end
  end
end
