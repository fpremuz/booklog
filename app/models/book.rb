class Book < ApplicationRecord
  validates :title, presence: true
  validates :status, presence: true
  has_one_attached :cover_image
  belongs_to :user
  has_many :book_tags
  has_many :tags, through: :book_tags

  scope :search, ->(q) { where("title ILIKE ? OR description ILIKE ?", "%#{q}%", "%#{q}%") }
  scope :with_status, ->(status) { where(status: status) }
  scope :with_rating, ->(rating) { where(rating: rating) }
  scope :rating_above, ->(min) { where("rating >= ?", min) }
  scope :with_tags, ->(tags) { joins(:tags).where("tags.name ILIKE ANY (ARRAY[?])", tags.map { |t| "%#{t}%" }).distinct }
  scope :publicly_visible, -> { where(public: true) }
  
  STATUS_OPTIONS = [
    ["To Read", "to read"],
    ["Reading", "reading"],
    ["Read", "read"],
    ["Wishlist", "wishlist"]
  ]
end
