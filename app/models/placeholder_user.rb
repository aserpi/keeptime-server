class PlaceholderUser < User
  has_one :workspace, required: true

  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :workspace }
  validates :username, uniqueness: { scope: :workspace }
  validate :no_same_username_in_workspace

  def no_same_username_in_workspace
    workspace.supervisor.username != username
  end

  def self.abstract_class?
    false
  end
end
