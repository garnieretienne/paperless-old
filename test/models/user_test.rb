require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new first_name: "Eric", last_name: "Smith", email: "eric.smith@provider.tld"
    train_users_classifier
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

  test "should train classifier with a document if the document text has changed" do
    user = users(:etienne)
    document = user.documents.first
    label = document.label
    classifier = user.classifier
    document.text = "My new text"
    assert_difference "classifier.count_tokens(:#{label.to_sym})", document.text.split(/\W/).size - document.text_was.split(/\W/).size do
      user.train_classifier_with_document document
    end
  end

  test "should train classifier with a document if the document label has changed" do
    user = users(:etienne)
    document = user.documents.first
    label = Label.where("id <> #{document.label_id}").first
    classifier = user.classifier
    document.label = label
    assert_difference "classifier.count_examples(:#{label.to_sym})", 1 do
      user.train_classifier_with_document document
    end
  end

  test "should untrain classifier with a document if the document label has changed" do
    user = users(:etienne)
    document = user.documents.first
    label = Label.where("id <> #{document.label_id}").first
    classifier = user.classifier
    document.label = label
    old_label = Label.find(document.label_id_was)
    assert_difference "classifier.count_examples(:#{old_label.to_sym})", -1 do
      user.train_classifier_with_document document
    end
  end

  private

  def train_users_classifier
    users = User.all
    users.each do |user|
      user.labels.each do |label|
        label.documents.each do |document|
          user.classifier.train label.to_sym, document.text
        end
      end
    end
  end
end
