class AddLabelToDocument < ActiveRecord::Migration
  def change
    add_reference :documents, :label, index: true
  end
end
