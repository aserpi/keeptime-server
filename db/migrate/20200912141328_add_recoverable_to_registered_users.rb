class AddRecoverableToRegisteredUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :registered_users, :reset_password_sent_at, :timestamp
    add_column :registered_users, :reset_password_token, :string, null: true
    add_index :registered_users, :reset_password_token, unique: true
  end
end
