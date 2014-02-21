class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  has_many :pages

  validates :title, presence: true, uniqueness: true
  validates :file, presence: true

  before_create :extract_pages

  def title=(new_title)
    super new_title.try(:titleize)
  end

  def to_filename
    "#{title.gsub(/ /, '_')}.pdf"
  end

  def thumb
    pages.first.snapshot.thumb
  end

  def extract_pages
    Dir.mktmpdir do |tmp|

      extracted_pages = Paperless::PDFUtils.convert_to_images file.path, 
        output: tmp,
        dpi: 150
      extracted_pages.each_index do |index|
        snapshot_filename = extracted_pages[index]
        pages.new number: index + 1, snapshot: File.new("#{tmp}/#{snapshot_filename}")
      end
    end
    pages
  end
end
