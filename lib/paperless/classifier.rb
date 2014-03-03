module Paperless

  class Classifier

    def initialize(id)
      @classifier = NBayes::Base.new
    end

    def train(category, text)
      @classifier.train tokenize(text), category.to_sym
    end

    def classify(text)
      @classifier.classify(tokenize(text)).max_class
    end

    private

    def tokenize(text)
      text.split /\s+/
    end
  end
end