class User < ApplicationRecord
  validates :name, length: { in: 2..32 }
  validates :username, format: { with: /\A(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])\z/ }

  self.abstract_class = true
end
