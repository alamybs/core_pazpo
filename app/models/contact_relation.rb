class ContactRelation < ApplicationRecord
  belongs_to :contact_book
  belongs_to :user

  validates :contact_book_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true

  enum status: {'owner': 0, 'friend': 1}
end
