class User < ApplicationRecord
  mount_uploader :picture, AvatarUploader
  has_many :properties

  has_many :follows
  has_many :get_users, :class_name => 'Follow', :foreign_key => 'user_id'
  has_many :get_follows, :class_name => 'Follow', :foreign_key => 'follow_id'


  validates_uniqueness_of :account_kit_id
  validates :name, :email, :phone_number, presence: true
  validates :account_kit_id, presence: true, on: :create

  enum role: {'Property Agen': 1, 'Independent Agent': 2}

  has_secure_token :authentication_token

  def followers
    User.where(id: get_follows.where(follow_id: id).pluck(:user_id))
  end
  def followings
    User.where(id: get_users.pluck(:follow_id))
  end
end
