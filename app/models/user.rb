class User < ApplicationRecord
  validates :name,:email,:phone_number,:authentication_token, presence: true, on: :create
  enum role: {'Property Agen': 1,'Independent Agent': 2}
end
