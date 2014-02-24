require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  def setup
    @file = File.new fixture_file_path('empty.pdf')
    @document = Document.new title: "My Document", file: @file
  end

  test "should create a correct document" do
    assert @document.valid?
  end

  test "should have a title" do
    @document.title = nil
    assert !@document.valid?
    assert @document.errors[:title].include? "can't be blank"
  end

  test "title should be unique" do
    @document.title = "Document 1"
    assert !@document.valid?
    assert @document.errors[:title].include? "has already been taken"
  end

  test "should have a file" do
    document = Document.new title: "My Document"
    assert !document.valid?
    assert document.errors[:file].include? "can't be blank"
  end

  test "should extract pages from the document at creation" do
    assert @document.save
    assert_equal 1, @document.pages.count
  end

  test "should extract text from the document at creation" do
    document = Document.create title: "OCR test", file: File.new(fixture_file_path('ocr.pdf'))
    assert_not_empty document.text
  end

  test "should display the first page thumbnail as document thumbnail" do
    document = documents(:two)
    assert_equal document.pages.first.snapshot.thumb.url, document.thumb.url
  end

  test "should return all unclassed documents" do
    assert_equal 1, Document.unclassed.count
  end
end
