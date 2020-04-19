class User < ApplicationRecord
  validates :name, length: { in: 2..32 }

  def self.abstract_class?
    true
  end
end
