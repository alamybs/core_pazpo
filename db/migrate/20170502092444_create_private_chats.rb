class CreatePrivateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :private_chats, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :group_ch, null: false
      t.string :member_ch, null: false

      t.timestamps
    end
    add_column :users, :channel, :string
    add_index :users, :channel, unique: true
    add_index :private_chats, :group_ch, unique: true
    add_index :private_chats, [:user_id, :member_ch], unique: true
  end
end
