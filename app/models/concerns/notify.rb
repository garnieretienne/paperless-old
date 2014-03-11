module Notify

  def notify(message, object)
    case message
    when :document_updated
      document_updated_event object
    end
  end

  def document_updated_event(object)
    send :train_classifier_with_document, object
  end
end