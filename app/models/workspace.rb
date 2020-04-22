class Workspace < ApplicationRecord
  belongs_to :supervisor, class_name: RegisteredUser.name, inverse_of: :supervised_workspaces
  has_and_belongs_to_many :registered_users, before_remove: :check_supervisor
  has_many :placeholder_users, dependent: :destroy

  validates :name, length: { in: 2..32 }
  validates :supervisor, inclusion: { in: ->(workspace) { workspace.registered_users } }

  private

  def check_supervisor(user)
    raise "removing_supervisor" if user == supervisor
  end
end
