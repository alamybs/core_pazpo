class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.integer :role, null: false
      t.string :picture
      t.string :authentication_token, null: false

      t.timestamps
    end
    add_index :users, [:authentication_token, :email], unique: true
  end
end
