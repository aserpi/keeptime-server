class Workspace < ApplicationRecord
  belongs_to :supervisor, class_name: RegisteredUser.name, inverse_of: :supervised_workspaces
  has_and_belongs_to_many :registered_users
  has_many :placeholder_users, dependent: :destroy
end
