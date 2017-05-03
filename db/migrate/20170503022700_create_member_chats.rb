class CreateMemberChats < ActiveRecord::Migration[5.0]
  def change
    create_table :member_chats, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :chat_id, null: false

      t.timestamps
    end
    add_index :member_chats, [:user_id, :chat_id], unique: true
  end
end
