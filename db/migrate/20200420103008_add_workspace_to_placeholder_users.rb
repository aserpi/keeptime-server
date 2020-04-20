class AddWorkspaceToPlaceholderUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :placeholder_users, :workspace, null: false, foreign_key: true
  end
end
