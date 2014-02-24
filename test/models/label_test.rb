require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  
  test "should create a correct label" do
    label = Label.new name: "Letters", tags: "subject to from"
    assert label.save
  end

  test "should have a unique name" do
    label = Label.new
    assert !label.valid?
    assert label.errors[:name].include? "can't be blank"
    label.name = "Invoices"
    assert !label.valid?
    assert label.errors[:name].include? "has already been taken"
  end

  test "should have tag list" do
    label = Label.new name: "Bank"
    assert !label.valid?
    assert label.errors[:tags].include? "can't be blank"
  end

  test "should print the label name when asking for string representation" do
    assert_equal "Invoices", labels(:invoices).to_s
  end
end
