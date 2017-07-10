class CreateContactRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_relations, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :contact_book_id, null: false
      t.integer :status, null: false

      t.timestamps
    end
    add_index :contact_relations, [:contact_book_id, :user_id, :status], unique: true, :name => 'index_c_r_on_c_b_id_and_u_id_and_s'
  end
end
