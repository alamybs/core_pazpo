class
User < ApplicationRecord
  mount_uploader :picture, AvatarUploader
  has_many :properties
  validates_uniqueness_of :account_kit_id
  validates :name, :email, :phone_number, presence: true
  validates :account_kit_id, presence: true, on: :create

  enum role: {'Property Agen': 1, 'Independent Agent': 2}

  has_secure_token :authentication_token
end
