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

  test "rails serialization" do
    dump = @classifier.dump(@classifier)
    assert_not_nil dump
    assert_instance_of Paperless::Classifier, @classifier.load(dump)
  end
end