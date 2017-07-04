class MemberChat < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  validates :user, presence: true
  validates :chat, presence: true
  validates :user_id, uniqueness: { scope: :chat_id, message: 'already on chat' }

end
