class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  has_many :pages
  belongs_to :label
  belongs_to :user

  validates :title, presence: true, uniqueness: {scope: :user_id}
  validates :file, presence: true
  validates :user, presence: true

  default_scope { order(created_at: :desc) }
  scope :unclassed, -> {where(label_id: nil)}
  scope :recent, -> {where("created_at >= ?", 10.day.ago)}

  before_validation :convert_images_to_pdf, on: :create
  after_commit :post_process, on: :create

  # Notify user a document has been updated
  after_save {|document| user.notify :document_updated, document}

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

  private

  def convert_images_to_pdf
    uploaded_file = file.file
    if uploaded_file.content_type.start_with? "image/"
      cache_dir = File.dirname(file.current_path)
      pdf_file_path = Paperless::PDFUtils.convert_to_pdf file.current_path, output: File.dirname(file.current_path)
      self.file = File.new "#{cache_dir}/#{pdf_file_path}"
    end
  end
end
