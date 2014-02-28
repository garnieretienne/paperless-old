require 'test_helper'

class LabelTest < ActiveSupport::TestCase

  def setup
    @owner = users(:etienne)
  end
  
  test "should create a correct label" do
    label = Label.new name: "Letters", user: @owner
    assert label.valid?
  end

  test "must have an user" do
    label = Label.new name: "Incoming"
    assert !label.valid?
    assert label.errors[:user].include? "can't be blank"
  end

  test "must have a unique name in the user scope" do
    label = Label.new user: @owner
    assert !label.valid?
    assert label.errors[:name].include? "can't be blank"
    label.name = "Invoices"
    assert !label.valid?
    assert label.errors[:name].include? "has already been taken"
  end

  test "should print the label name when asking for string representation" do
    assert_equal "Invoices", labels(:invoices).to_s
  end
end
