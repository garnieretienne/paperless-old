class LabelsController < ApplicationController

  def new
    @label = current_user.labels.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      redirect_to documents_path
    else
      render :new
    end
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end
end
