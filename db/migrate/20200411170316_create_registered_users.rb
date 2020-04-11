class CreateRegisteredUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :registered_users do |t|
      t.string :email
      t.string :name
      t.string :username

      t.timestamps
    end
    add_index :registered_users, :email, unique: true
    add_index :registered_users, :username, unique: true
  end
end
