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
    assert !@document.save
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
end
