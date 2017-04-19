class UpdateIndexInUser < ActiveRecord::Migration[5.0]
  def change
    remove_index(:users, :name => 'index_users_on_authentication_token_and_email')

    add_index :users, :account_kit_id, unique: true
    add_index :users, :authentication_token, unique: true
    add_index :users, :email, unique: true
  end
end
