class Property < ApplicationRecord
  belongs_to :user
  validates :description, :price, :property_category_id, :property_type, presence: true
  enum property_category_id: {'Rumah': 1, 'Ruko': 2, 'Apartemen': 3, 'Gudang': 4, 'Kantor': 5, 'Tanah': 6}
  enum property_type: {'WTB': 1, 'WTS': 2}

  def property_category
    {title: property_category_id}
  end

  def self.reformat_price(price)
    price.gsub(/\D/, '')
  end
end
