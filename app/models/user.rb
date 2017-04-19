class User < ApplicationRecord
  has_many :properties

  validates :name, :email, :phone_number, presence: true
  validates :account_kit_id, presence: true, on: :create

  enum role: {'Property Agen': 1, 'Independent Agent': 2}

  has_secure_token :authentication_token
end