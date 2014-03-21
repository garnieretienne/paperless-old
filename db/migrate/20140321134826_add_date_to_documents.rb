class AddDateToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :date, :date
  end
end
