class AddAccountKitIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :account_kit_id, :string
    add_index :users, [:account_kit_id], unique: true
  end
end
