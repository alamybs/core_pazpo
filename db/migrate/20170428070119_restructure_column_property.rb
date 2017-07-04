class RestructureColumnProperty < ActiveRecord::Migration[5.0]
  def change
    remove_column :properties, :property_category_id
  end
end
