class Book < ApplicationRecord
  validates :title, presence: true
  validates :status, presence: true
  has_one_attached :cover_image
  
  STATUS_OPTIONS = [
    ["To Read", "to read"],
    ["Reading", "reading"],
    ["Read", "read"],
    ["Wishlist", "wishlist"]
  ]
end
