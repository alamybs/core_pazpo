class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties, id: :uuid do |t|
      t.integer :property_category_id, null: false
      t.text :description, null: false
      t.decimal :price, :precision => 16, :scale => 2, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
