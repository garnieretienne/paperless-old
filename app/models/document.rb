class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader

  has_many :pages

  validates :title, presence: true
  validates :file, presence: true

  before_create :extract_pages

  def title=(new_title)
    super new_title.try(:titleize)
  end

  def to_filename
    "#{title.gsub(/ /, '_')}.pdf"
  end

  private

  def extract_pages
    Dir.mktmpdir do |path|
      tmp = Dir.new path
      extracted_pages = []

      Docsplit.extract_images file.url,
        output: tmp.path,
        density: 72,
        format: :png
      
      tmp.each{|filename| extracted_pages << filename if filename =~ /\.png$/ }

      extracted_pages.sort!{ |page_1, page_2| page_1.match(/(\d*).png/)[1].to_i <=> page_2.match(/(\d*).png/)[1].to_i }

      extracted_pages.each_index do |index|
        snapshot_filename = extracted_pages[index]
        pages.new number: index, snapshot: File.new("#{tmp.path}/#{snapshot_filename}")
      end
    end
  end
end
