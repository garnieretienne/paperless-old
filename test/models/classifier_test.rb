require 'test_helper'

class ClassifierTest < ActiveSupport::TestCase

	def setup
		@classifier = Paperless::Classifier.new "testing"
		@classifier.train :good, "I'm the good one"
		@classifier.train :bad, "I'm the bad one"
	end

	test "string classification" do
		assert_equal :good, @classifier.classify("Good joke ! Love this one")
	end
end