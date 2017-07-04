class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :followers, class_name: :User, foreign_key: :follow_id
  belongs_to :followings, class_name: :User, foreign_key: :user_id

  validates :user_id, uniqueness: {scope: [:follow_id]}
end
