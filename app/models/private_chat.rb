class PrivateChat < ApplicationRecord
  belongs_to :user
  validates :member_ch, presence: true
  before_create :set_channel
  private
  def set_channel
    self.group_ch  = generate_channel
  end
  def generate_channel
    loop do
      ch = "private_#{SecureRandom.hex(10).downcase}"
      break ch unless User.where(channel: ch).exists?
    end
  end
end
