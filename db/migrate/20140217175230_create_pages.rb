class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :number, null: false
      t.string :snapshot, null: false
      t.references :document, null: false

      t.timestamps
    end
  end
end
