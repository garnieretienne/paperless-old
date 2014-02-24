require "paperless/ocr"

module Paperless
  
  # Need poppler-utils installed
  class PDFUtils
    
    def self.convert_to_images(pdf_path, options = {})
      dpi = options[:dpi] || 150
      format = options[:format] || :jpeg
      prefix = options[:prefix] || "page"
      output = options[:output] || "./"

      output_dir = Dir.new(output)
      extracted_pages = []

      `pdftoppm -r #{dpi} -#{format} -q "#{pdf_path}" #{output}/#{prefix}`

      output_dir.each{|filename| extracted_pages << filename if filename =~ /#{prefix}-\d*\./ }
      
      extracted_pages.sort{ |page_1, page_2| page_1 <=> page_2 }
    end

    def self.extract_images(pdf_path, options = {})
      prefix = options[:prefix] || "image"
      output = options[:output] || "./"

      output_dir = Dir.new(output)
      extracted_images = []

      `pdfimages "#{pdf_path}" #{output}/#{prefix}`

      output_dir.each{|filename| extracted_images << filename if filename =~ /#{prefix}-\d*\./ }

      extracted_images.sort{ |image_1, image_2| image_1 <=> image_2 }
    end

    def self.extract_text(pdf_path)
      tmpfile = Tempfile.new "text"
      extracted_text = ""

      `pdftotext "#{pdf_path}" #{tmpfile.path}`

      data = IO.read tmpfile.path
    end

    def self.extract_text_from_file_and_using_ocr(pdf_path)
      data = extract_text pdf_path

      Dir.mktmpdir do |tmp|
        images = extract_images pdf_path, output: tmp
        images.each do |image|
          data << Paperless::OCR.extract("#{tmp}/#{image}")
        end
      end

      data
    end
  end
end