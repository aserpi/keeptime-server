class PlaceholderUser < User
  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.abstract_class?
    false
  end
end
