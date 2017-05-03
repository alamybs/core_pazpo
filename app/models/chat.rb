class Chat < ApplicationRecord
  has_many :member_chats, dependent: :destroy
  validates :chat_type, presence: true

  enum chat_type: {'private_chat': 1, 'group_chat': 2}

  before_create :set_channel

  private
  def set_channel
    self.channel = generate_channel
  end

  def generate_channel
    loop do
      if Chat.chat_types[chat_type].eql?(1)
        ch = "p_#{SecureRandom.hex(10).downcase}"
        break ch unless User.where(channel: ch).exists?
      elsif Chat.chat_types[chat_type].eql?(2)
        ch = "g_#{SecureRandom.hex(10).downcase}"
        break ch unless User.where(channel: ch).exists?
      end
    end
  end
end
