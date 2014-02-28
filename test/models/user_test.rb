require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new first_name: "Eric", last_name: "Smith", email: "eric.smith@provider.tld"
  end

  test "should create a valid user" do
    assert @user.valid?
  end
  
  test "must have an email, a first name and a last name" do
    user = User.new
    assert !user.valid?
    assert user.errors[:email].include? "can't be blank"
    assert user.errors[:first_name].include? "can't be blank"
    assert user.errors[:last_name].include? "can't be blank"
  end

  test "must have a unique email address" do
    user = User.new first_name: "Etienne", last_name: "Garnier", email: users(:etienne).email
    assert !user.valid?
    assert user.errors[:email].include? "has already been taken"
  end

  test "should create default labels when user is created" do
    @user.save
    assert_not_empty @user.labels
  end
end
