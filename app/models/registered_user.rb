class RegisteredUser < User
  extend Devise::Models
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_and_belongs_to_many :workspaces
  has_many :supervised_workspaces, class_name: Workspace.name, inverse_of: :supervisor

  validates :username, uniqueness: true
end
