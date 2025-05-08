class Tag < ApplicationRecord
  belongs_to :user
  has_many :book_tags, dependent: :destroy
  has_many :books, through: :book_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.to_s.strip.downcase.capitalize
  end

end
