class CreatePlaceholderUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :placeholder_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
