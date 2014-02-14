class Document < ActiveRecord::Base

  # Validations
  validates :title, presence: true
  validates :source, presence: true

  def title=(new_title)
    super new_title.try(:titleize)
  end

  def file=(uploaded_file)
    self.source = Paperless::Store.put(uploaded_file.path, uploaded_file.original_filename)
  end

  def file
    Paperless::Store.get_path self.source
  end

  def to_filename
    "#{title.gsub(/ /, '_')}.pdf"
  end
end
