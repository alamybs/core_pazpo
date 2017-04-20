class AddPropertyTypeToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :property_type, :integer, null: false
  end
end
