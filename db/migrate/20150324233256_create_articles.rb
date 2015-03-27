class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :name
      t.text :description
      t.integer :price
      t.integer :total_in_shelf
      t.integer :total_in_vault
      t.references :store, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
