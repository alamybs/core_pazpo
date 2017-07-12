class AllowEmail < ActiveRecord::Migration[5.0]
  def change
    change_column :contact_books, :email, :string, null: true
  end
end
