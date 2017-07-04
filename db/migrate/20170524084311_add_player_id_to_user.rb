class AddPlayerIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :player_id, :string
    add_index :users, :player_id, unique: true
  end
end
