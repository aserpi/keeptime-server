class AddUsernameToPlaceholderUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :placeholder_users, :username, :string
  end
end
