class User < ApplicationRecord
  validates :name,:email,:phone_number,:account_kit_id, presence: true, on: :create
  enum role: {'Property Agen': 1,'Independent Agent': 2}
  has_secure_token :authentication_token
end
