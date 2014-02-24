class AddTagsToLabels < ActiveRecord::Migration
  def change
    add_column :labels, :tags, :text
  end
end
