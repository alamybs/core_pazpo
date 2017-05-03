class MemberChat < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  validates :user, presence: true
  validates :chat, presence: true
end
