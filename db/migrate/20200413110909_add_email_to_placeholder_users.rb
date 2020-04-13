class AddEmailToPlaceholderUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :placeholder_users, :email, :string
  end
end
