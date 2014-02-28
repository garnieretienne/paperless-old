class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  has_many :pages
  belongs_to :label

  validates :title, presence: true, uniqueness: true
  validates :file, presence: true

  default_scope { order(created_at: :desc) }
  scope :unclassed, -> {where(label_id: nil)}
  scope :recent, -> {where("created_at >= ?", 10.day.ago)}

  def self.new_from_file(params)
    file = params[:file]
    filename = file.respond_to?(:original_filename) ? file.original_filename : File.basename(file)
    title = File.basename(filename, File.extname(filename)).titleize(humanize: false, underscore: false).gsub(/_/, ' ')
    Document.new(title: title, file: file)
  end

  def date
    created_at.to_date.to_formatted_s(:long)
  end

  def to_filename
    "#{title.gsub(/ /, '_')}.pdf"
  end

  def title_with_label
    label ? "#{label.name} / #{title}" : title
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

  def post_process
    ExtractPagesWorker.perform_async(self.id)
    ExtractTextWorker.perform_async(self.id)
  end
end
