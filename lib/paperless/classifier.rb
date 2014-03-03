module Paperless

  class Classifier

    attr_reader :classifier

    def initialize
      @classifier = NBayes::Base.new
    end

    def train(category, text)
      @classifier.train tokenize(text), category.to_sym
    end

    def classify(text)
      @classifier.classify(tokenize(text)).max_class
    end

    def dump(object)
      @classifier.dump(@classifier)
    end

    def load(yaml)
      @classifier.load(yaml)
      self
    end

    private

    def tokenize(text)
      text.split /\s+/
    end
  end
end