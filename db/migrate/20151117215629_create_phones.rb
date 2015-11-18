class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number
      t.references :contact

      t.timestamps null: false
    end
    add_index :phones, [:contact_id, :number], unique: true
    
  end
end
