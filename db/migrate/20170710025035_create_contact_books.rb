class CreateContactBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_books, id: :uuid do |t|
      t.string :phone_number, null: false
      t.string :email, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :contact_books, [:phone_number], unique: true
  end
end
