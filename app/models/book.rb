class Book < ApplicationRecord
  validates :isbn, presence: true, length: { maximum: 15 }
  validates :title, presence: true, length: { maximum: 30 }
  validates :authors, presence: true
  validates :published, presence: true
  validates :edition, presence: true
  validates :language, presence: true
  validates :quantity, presence: true, length: { maximum: 2 }
  validates_uniqueness_of :isbn, confirmation: { case_sensitive: false }
  has_one_attached :portrait, dependent: :destroy
  has_many :checkout, dependent: :restrict_with_error
end
