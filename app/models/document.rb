class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  # Validations
  validates :title, presence: true
  validates :file, presence: true

  def title=(new_title)
    super new_title.try(:titleize)
  end

  def to_filename
    "#{title.gsub(/ /, '_')}.pdf"
  end
end
