class AddUserToLabels < ActiveRecord::Migration
  def change
    add_reference :labels, :user, index: true
  end
end
