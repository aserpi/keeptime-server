class CreateWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.text :description
      t.references :supervisor, null: false, foreign_key: { to_table: :registered_users }

      t.timestamps
    end
  end
end
