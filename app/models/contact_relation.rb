class ContactRelation < ApplicationRecord
  belongs_to :contact_book
  belongs_to :user

  validates :contact_book_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
  validates_uniqueness_of :status, scope: [:contact_book_id, :user_id]

  enum status: {'owner': 0, 'friend': 1}
end
