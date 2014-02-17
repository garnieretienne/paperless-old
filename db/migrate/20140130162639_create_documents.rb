class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title, null: false, unique: true
      t.string :file, null:false, unique: true

      t.timestamps
    end
  end
end
