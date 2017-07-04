class Property < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  validates :description, :price, :property_type, presence: true

  enum property_type: {'#dijual': 1, '#dicari': 2}

  def self.reformat_price(price)
    price.gsub(/\D/, '')
  end
end
