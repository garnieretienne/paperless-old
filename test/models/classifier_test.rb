require 'test_helper'

class ClassifierTest < ActiveSupport::TestCase

  def setup
    @classifier = Paperless::Classifier.new
    @classifier.train :good, "I'm the good one"
    @classifier.train :bad, "I'm the bad one"
  end

  test "string classification" do
    assert_equal :good, @classifier.classify("Good joke ! Love this one")
  end

  test "untraining" do
    @classifier = Paperless::Classifier.new
    @classifier.untrain :good, "I'm the good one"
    assert_not_equal :good, @classifier.classify("I'm the good one")
  end

  test "rails serialization" do
    dump = @classifier.dump(@classifier)
    assert_not_nil dump
    assert_instance_of Paperless::Classifier, @classifier.load(dump)
  end

  test "categories list" do
    assert @classifier.categories.include?(:good)
  end

  test "count examples" do
    assert_equal 1, @classifier.count_examples(:good)
  end

  test "count tokens" do
    assert_equal 4, @classifier.count_tokens(:good)
  end
end