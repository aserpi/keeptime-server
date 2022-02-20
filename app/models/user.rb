class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true
  validates :name, length: { in: 2..32 }
  validates :username, uniqueness: true,
            format: { with: /\A(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])\z/ }

  has_and_belongs_to_many :workspaces
  has_many :supervised_workspaces, class_name: Workspace.name, inverse_of: :supervisor

  private

  def registered?
    self.email.nil?
  end
end
