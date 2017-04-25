class CreateFollows < ActiveRecord::Migration[5.0]
  def change
    create_table :follows, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :follow_id, null: false

      t.timestamps
    end
    add_index :follows, [:user_id, :follow_id], unique: true
  end
end
