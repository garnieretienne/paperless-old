require 'test_helper'

class PDFUtilsTest < ActiveSupport::TestCase

  def setup
    @working_dir_path = Dir.mktmpdir
    @pdf_path = fixture_file_path "ocr.pdf"
  end

  def teardown
    FileUtils.rm_r @working_dir_path
  end
  
  test "should convert a PDF to images" do
    extracted_pages = Paperless::PDFUtils.convert_to_images @pdf_path, output: @working_dir_path
    assert_equal ["page-1.jpg", "page-2.jpg"], extracted_pages
  end

  test "should extract images from a PDF file" do
    extracted_images = Paperless::PDFUtils.extract_images @pdf_path, output: @working_dir_path
    assert_equal ["image-000.ppm"], extracted_images
  end

  test "should extract text from a PDF file" do
    extracted_text = Paperless::PDFUtils.extract_text @pdf_path
    assert_match /Lorem ipsum dolor sit amet/, extracted_text
  end

  test "should extract text from a PDF file and from images inside a PDF file" do
    extracted_text = Paperless::PDFUtils.extract_text! @pdf_path
    assert assert_match /Lorem ipsum dolor sit amet/, extracted_text
    assert assert_match /Hello from picture !/, extracted_text
  end
end
