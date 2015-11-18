class Contact < ActiveRecord::Base
  has_many :emails, dependent: :destroy
  has_many :phones, dependent: :destroy
  
  accepts_nested_attributes_for :emails, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  
  validates :first_name, uniqueness: { scope: :last_name, case_sensitive: false }   
  
  validate do
    unless self.phones.any? 
      unless self.emails.any?
        errors.add(:base, :one_phone_or_email_required)
      end
    end
  end
#  include PgSearch
#  pg_search_scope :search_by_full_name, against: [:first_name, :last_name]
  
  def email_addresses
    emails.map(&:address)
  end
  
  def phone_numbers
    phones.map(&:number)
  end
  
  class << self
    def import(file)
      errors = []
      CSV.foreach(file.path, headers: true) do |row|

        contact_hash = row.to_hash # exclude the price field
        contact = Contact.where(
          first_name: contact_hash['First Name'],
          last_name: contact_hash['Last Name']
        ).first_or_initialize
        
        email_addresses = contact_hash['Email Addresses'] && contact_hash['Email Addresses'].split(';') || []
        phone_numbers = contact_hash['Phone Numbers'] && contact_hash['Phone Numbers'].split(';') || []
        
        if contact.new_record?
          email_addresses.each do |email_address|
            email = contact.emails.build(address: email_address)
          end
          
          phone_numbers.each do |phone_number|
            phone = contact.phones.build(number: phone_number)
          end
          contact.save
          errors << {row: contact_hash, error: contact.errors.full_messages} if contact.errors.any?
        else
          email_addresses.each do |email_address|
            email = contact.emails.where(address: email_address).first_or_create
            errors << {row: contact_hash, error: email.errors.full_messages} if email.errors.any?            
          end
          
          phone_numbers.each do |phone_number|
            phone = contact.phones.where(number: phone_number).first_or_create
            errors << {row: contact_hash, error: phone.errors.full_messages} if phone.errors.any?            
          end
          
        end
      end
      errors
    end
  end
end
