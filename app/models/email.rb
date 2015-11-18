class Email < ActiveRecord::Base

  REGEX_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

  before_validation do 
    self.address &&  self.address.strip!
  end

  validates :address, 
    presence: true,
    length: { in: 3..254 },
    format: { with: REGEX_EMAIL }

  belongs_to :contact, inverse_of: :emails
  validates :address, presence: true, uniqueness: { scope: :contact_id, case_sensitive: false }   

end