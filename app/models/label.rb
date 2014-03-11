class Label < ActiveRecord::Base
  has_many :documents
  belongs_to :user

  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates :user, presence: true

  default_scope { order(:name) }

  def to_s
    name
  end

  def to_sym
    name.to_sym
  end
end
