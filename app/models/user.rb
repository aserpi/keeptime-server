class User < ApplicationRecord
  validates :name, presence: true

  def self.abstract_class?
    true
  end
end
