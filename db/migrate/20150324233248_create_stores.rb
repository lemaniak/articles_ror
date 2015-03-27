class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.text :name
      t.string :address
      t.string :text

      t.timestamps null: false
    end
  end
end
