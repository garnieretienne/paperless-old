class Label < ActiveRecord::Base
  has_many :documents

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
