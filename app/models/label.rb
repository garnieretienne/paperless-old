class Label < ActiveRecord::Base
  has_many :documents
  belongs_to :user

  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates :user, presence: true

  default_scope { order(:name) }

  # Notify user the label has been deleted
  after_destroy {|label| user.notify :label_deleted, document}

  def to_s
    name
  end

  def to_sym
    name.to_sym
  end
end
