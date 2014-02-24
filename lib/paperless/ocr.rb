module Paperless

  # Need tesseract installed
  class OCR

    def self.extract(image_path)
      data = ""
      Dir.mktmpdir do |tmp|
        `tesseract "#{image_path}" #{tmp}/result`
        data = IO.read "#{tmp}/result.txt"
      end
      data
    end   
  end
end