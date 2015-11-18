class Phone < ActiveRecord::Base
  belongs_to :contact, inverse_of: :emails
  validates :number, presence: true, uniqueness: { scope: :contact_id, case_sensitive: false }   

  before_validation do 
    self.number &&  self.number.strip!
  end
  validates :number, 
    presence: true,
    length: { in: 4..12 }
  
end
