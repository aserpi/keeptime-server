class RegisteredUser < User
  extend Devise::Models
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :email, presence: true
  validates :username, presence: true

  def self.abstract_class?
    false
  end
end
