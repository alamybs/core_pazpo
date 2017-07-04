class ChangePrivateTabelToChat < ActiveRecord::Migration[5.0]
  def change
    drop_table :private_chats
    create_table :chats, id: :uuid do |t|
      t.string :channel, null: false
      t.integer :chat_type, null: false
      t.timestamps
    end
  end
end
