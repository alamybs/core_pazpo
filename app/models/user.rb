class User < ApplicationRecord
  mount_uploader :picture, AvatarUploader
  has_many :properties
  has_many :member_chats
  has_many :chats, through: :member_chats

  has_many :follows
  has_many :get_users, :class_name => 'Follow', :foreign_key => 'user_id'
  has_many :get_follows, :class_name => 'Follow', :foreign_key => 'follow_id'


  validates_uniqueness_of :account_kit_id
  validates :name, :email, :phone_number, presence: true
  validates :account_kit_id, presence: true, on: :create
  validates :player_id, presence: true, on: :create
  before_create :set_channel

  enum role: {'Property Agen': 1, 'Independent Agent': 2}

  has_secure_token :authentication_token

  def followers
    User.where(id: get_follows.where(follow_id: id).pluck(:user_id))
  end

  def followings
    User.where(id: get_users.pluck(:follow_id))
  end

  def me_and_followings
    User.where(id: get_users.pluck(:follow_id)+[self.id])
  end

  def info
    {
      total:{
        followers:  followers.size,
        followings: followings.size,
      }
    }
  end

  private
  def set_channel
    self.channel = generate_channel
  end

  def generate_channel
    loop do
      ch = "u_#{SecureRandom.hex(10).downcase}"
      break ch unless User.where(channel: ch).exists?
    end
  end
end
