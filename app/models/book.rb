class Book < ApplicationRecord
  validates :title, presence: true
  validates :status, presence: true
  
  STATUS_OPTIONS = [
    ["To Read", "to read"],
    ["Reading", "reading"],
    ["Read", "read"],
    ["Wishlist", "wishlist"]
  ]
end
