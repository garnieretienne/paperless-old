class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Load all labels as they are part of the layout
  before_filter :load_labels

  def current_user
  	@user ||= User.first
  end

  private

  def load_labels
    @labels = current_user.labels.all
  end
end
