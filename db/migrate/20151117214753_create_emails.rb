class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :address
      t.references :contact

      t.timestamps null: false
    end
    add_index :emails, [:contact_id, :address], unique: true
  end
end
