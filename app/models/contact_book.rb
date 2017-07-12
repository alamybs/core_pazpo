class ContactBook < ApplicationRecord
  has_many :contact_relations
  validates :phone_number, presence: true
  validates :phone_number, uniqueness: true

  validates :name, presence: true
  validates :name, format: {
    with:    /\A[a-zA-Z\s]+\z/,
    message: "Bukan nama sebenarnya!"}

  # validates :email, uniqueness: true
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, length: {maximum: 255},
  #           format:           {with: VALID_EMAIL_REGEX}

  def self.build_contact params
    contact_book = params[:contact_book]
    user         = params[:user]
    contact_book.contacts.each do |contact|
      cb = ContactBook.find_by(phone_number: contact.phone_number)
      if cb.present? && !cb.phone_number.eql?(user.phone_number)
        cr                 = user.contact_relations.new
        cr.contact_book_id = cb.id
        cr.status          = :friend
        cr.save
      else
        cb              = ContactBook.new
        cb.phone_number = contact.phone_number
        cb.email        = contact.email
        cb.name         = contact.name || "anonymous"
        if cb.save
          cr                 = user.contact_relations.new
          cr.contact_book_id = cb.id
          cr.status          = :friend
          cr.save
        end
      end
    end
  end
end
