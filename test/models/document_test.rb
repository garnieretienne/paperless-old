require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  def setup
    @file = File.new fixture_file_path('empty.pdf')
    @owner = users(:etienne)
    @document = Document.new title: "My Document", file: @file, user: @owner
  end

  test "should create a correct document" do
    assert @document.valid?
  end

  test "must have a title" do
    @document.title = nil
    assert !@document.valid?
    assert @document.errors[:title].include? "can't be blank"
  end

  test "must have an user" do
    @document.user_id = nil
    assert !@document.valid?
    assert @document.errors[:user].include? "can't be blank"
  end

  test "title must be unique in the user scope" do
    @document.title = "Document 1"
    assert !@document.valid?
    assert @document.errors[:title].include? "has already been taken"
  end

  test "must have a file" do
    document = Document.new title: "My Document"
    assert !document.valid?
    assert document.errors[:file].include? "can't be blank"
  end

  test "should extract pages from the document" do
    @document.extract_pages
    assert_equal 1, @document.pages.length
  end

  test "should extract text from the document" do
    document = Document.create title: "OCR test", file: File.new(fixture_file_path('ocr.pdf'))
    document.extract_text
    assert_not_empty document.text
  end

  test "should display the first page thumbnail as document thumbnail" do
    document = documents(:two)
    assert_equal document.pages.first.snapshot.thumb.url, document.thumb.url
  end

  test "should return all unclassed documents" do
    assert_equal 1, Document.unclassed.count
  end

  test "should create a valid document instance from a single PDF file" do
    document = Document.new_from_file file: @file
    document.user = @owner
    assert document.valid?
    assert_equal "Empty", document.title
  end
end
