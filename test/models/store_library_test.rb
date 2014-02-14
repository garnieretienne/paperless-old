require 'test_helper'

class StoreLibraryTest < ActionController::TestCase

  test "should return the path or url where the documents are stored" do
    assert_not_nil Paperless::Store.path
  end

  test "should store a file and retrieve the complete path" do
    filename = Paperless::Store.put fixture_file_path('empty.pdf'), 'empty.pdf'
    assert_equal 'empty.pdf', filename
    path = "#{Paperless::Store.path}/#{filename}"
    assert_equal path, Paperless::Store.get_path(filename)
    assert File.exist?(path)
  end
end
