require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def setup
    @snapshot = File.new fixture_file_path('snapshot.jpg')
    @page = Page.new document: documents(:one), number: 100, snapshot: @snapshot
  end

  test "should have a page number" do
    @page.number = nil
    assert !@page.valid?
    assert @page.errors[:number].include? "can't be blank"
  end

  test "should have a page snapshot" do
    page = Page.new document: documents(:one), number: 1
    assert !page.valid?
    assert page.errors[:snapshot].include? "can't be blank"
  end

  test "should belongs to a document" do
    page = Page.new number: 100, snapshot: @snapshot
    assert !page.valid?
    assert page.errors[:document].include? "can't be blank"
  end
  
  test "should have a unique page number in the document scope" do
    page_1 = Page.new document: documents(:one), number: 1
    assert !page_1.valid?
    assert page_1.errors[:number].include? "has already been taken"
  end
end
