class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

end
