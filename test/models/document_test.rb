require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  FileDouble = Struct.new(:path, :original_filename)

  def setup
    @file = FileDouble.new(fixture_file_path('empty.pdf'), "empty.pdf")
    @document = Document.new(title: "My Document", file: @file)
  end

  test "should create a correct document" do
    assert @document.valid?
  end

  test "should have a title" do
    @document.title = nil
    assert !@document.valid?
    assert @document.errors[:title].include? "can't be blank"
  end

  test "should have a source file" do
    @document.source = nil
    assert !@document.valid?
    assert @document.errors[:source].include? "can't be blank"
  end
end
