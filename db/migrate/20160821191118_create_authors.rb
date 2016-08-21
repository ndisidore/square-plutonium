class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.text :full_name,      null: false
      t.string :display_name, null: false
      t.integer :auth_level,  null: false, comment: 'User Role',  limit: 2
      t.string :email,        null: false
      t.string :uuid,         null: false

      t.timestamps
    end
  end
end
