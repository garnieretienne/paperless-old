class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  has_many :pages
  belongs_to :label

  validates :title, presence: true, uniqueness: true
  validates :file, presence: true

  default_scope { order(created_at: :desc) }
  scope :unclassed, -> {where(label_id: nil)}

  before_create :extract_pages, :extract_text

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

  def extract_text
    self.text = Paperless::PDFUtils.extract_text! file.path
  end
end
