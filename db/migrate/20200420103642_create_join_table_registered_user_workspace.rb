class CreateJoinTableRegisteredUserWorkspace < ActiveRecord::Migration[6.0]
  def change
    create_join_table :registered_users, :workspaces do |t|
      t.index [:registered_user_id, :workspace_id], name: :join_registered_user_workspace
      t.index [:workspace_id, :registered_user_id], name: :join_workspace_registered_user
    end
  end
end
