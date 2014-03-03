require 'ffi/aspell'

module Paperless

  # Need tesseract installed
  class OCR
    TESSERACT_LANGUAGE = ENV["TESSERACT_LANGUAGE"] || :eng

    def self.extract(image_path)
      data = ""
      Dir.mktmpdir do |tmp|
        `tesseract "#{pre_process_image(image_path, "#{tmp}/processed")}" #{tmp}/result -l #{TESSERACT_LANGUAGE}`
        data = IO.read "#{tmp}/result.txt"
      end
      data
    end

    def self.pre_process_image(image_path, new_image_path)
      `convert "#{image_path}" -normalize -density 300 -depth 8 -threshold 50% #{new_image_path}.png`
      "#{new_image_path}.png"
    end

    def self.post_process_text(text)
      words = []
      speller = FFI::Aspell::Speller.new
      speller.set('lang', 'fr_FR')
      speller.set('ignore-case', "true")

      text.gsub(/\W/  , " ").squeeze(" ").split(" ").each do |word|
        next if word.length < 3
        word.downcase!
        words << word if speller.correct?(word)
      end

      words.join(" ")
    end
  end
end