class Label < ActiveRecord::Base
  has_many :documents

  validates :name, presence: true, uniqueness: true

  default_scope { order(:name) }

  def to_s
    name
  end
end
