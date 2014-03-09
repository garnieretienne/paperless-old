require 'test_helper'

class OCRTest < ActiveSupport::TestCase

  def setup
    @image_path = fixture_file_path "image_ocr.jpg"
  end
  
  test "should extract text from an image" do
    assert_match /Hello from picture !/, Paperless::OCR.extract(@image_path)
  end

  test "text cleaner" do
    text = IO.read fixture_file_path("sample_ocr_output.txt")
    assert_match /john smith depot date tail/, Paperless::OCR.post_process_text(text)
  end
  
end