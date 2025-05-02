class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
  
end
