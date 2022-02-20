class Workspace < ApplicationRecord
  belongs_to :supervisor, class_name: User.name, inverse_of: :supervised_workspaces # TODO: must be registered
  has_and_belongs_to_many :users, before_remove: :check_supervisor

  validates :name, length: { in: 2..32 }
  validates :supervisor, inclusion: { in: ->(workspace) { workspace.users } }

  private

  def check_supervisor(user)
    raise "removing_supervisor" if user == supervisor
  end
end
