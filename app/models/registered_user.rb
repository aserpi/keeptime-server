class RegisteredUser < User
  extend Devise::Models
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :username, format: { with: /\A(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])\z/ }

  def self.abstract_class?
    false
  end
end
