class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Load all labels as they are part of the layout
  before_filter :load_labels

  private

  def load_labels
    @labels = Label.all
  end
end
