class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
    add_index :contacts, [:first_name, :last_name], unique: true
  end
end
