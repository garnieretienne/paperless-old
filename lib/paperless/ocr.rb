module Paperless

  # Need tesseract installed
  class OCR
    TESSERACT_LANGUAGE = ENV["TESSERACT_LANGUAGE"] || :eng

    def self.extract(image_path)
      data = ""
      Dir.mktmpdir do |tmp|
        `tesseract "#{image_path}" #{tmp}/result -l #{TESSERACT_LANGUAGE}`
        data = IO.read "#{tmp}/result.txt"
      end
      data
    end
  end
end