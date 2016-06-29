class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :item, index: true, foreign_key: true
      t.integer :days
      t.date :start

      t.timestamps null: false
    end
  end
end
