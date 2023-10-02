class Book < ApplicationRecord
  validates :isbn, presence: true
  validates :title, presence: true
  validates :authors, presence: true
  validates :published, presence: true
  validates :edition, presence: true
  validates :language, presence: true
  validates :quantity, presence: true
  validates_uniqueness_of :isbn, confirmation: { case_sensitive: false }
  has_one_attached :portrait
end
