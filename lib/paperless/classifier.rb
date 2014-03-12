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

    def categories
      @classifier.data.categories
    end

    def count_examples(category)
      @classifier.data.example_count category
    end

    def count_tokens(category)
      @classifier.data.token_count category
    end

    def delete_category(category)
      @classifier.delete_category category
    end

    # Support for Active Record 'serialize'
    def self.dump(object)
      YAML.dump(object)
    end

    # Support for Active Record 'serialize':
    # Load the classifier from the YAML data and execute NBayes 
    # special loading behavior.
    def self.load(yaml)
      paperless_classifier = yaml.nil? ? Paperless::Classifier.new : YAML.load(yaml)
      paperless_classifier.classifier.reset_after_import
      paperless_classifier
    end

    private

    def tokenize(text)
      text.downcase.gsub(/\W/, " ").squeeze("").split
    end
  end
end