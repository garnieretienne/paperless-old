class AddClassifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :classifier, :text
  end
end
