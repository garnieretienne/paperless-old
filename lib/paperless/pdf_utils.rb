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
  end
end