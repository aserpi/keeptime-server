class RegisteredUser < User
  validates :email, presence: true
  validates :username, presence: true

  def self.abstract_class?
    false
  end
end
