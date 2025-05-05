class Book < ApplicationRecord
  validates :title, presence: true
  validates :status, presence: true
  has_one_attached :cover_image
  belongs_to :user
  has_many :book_tags
  has_many :tags, through: :book_tags
  
  STATUS_OPTIONS = [
    ["To Read", "to read"],
    ["Reading", "reading"],
    ["Read", "read"],
    ["Wishlist", "wishlist"]
  ]
end
