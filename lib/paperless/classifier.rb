module Paperless

  class Classifier

    attr_reader :classifier

    def initialize
      @classifier = NBayes::Base.new
    end

    def train(category, text)
      @classifier.train tokenize(text), category.to_sym
    end

    def untrain(category, text)
      @classifier.untrain tokenize(text), category.to_sym
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

    def categories
      @classifier.data.categories
    end

    def count_examples(category)
      @classifier.data.example_count category
    end

    def count_tokens(category)
      @classifier.data.token_count category
    end

    private

    def tokenize(text)
      text.downcase.split /\s+/
    end
  end
end