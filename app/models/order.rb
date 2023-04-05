class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment
  has_many :order_items, dependent: :destroy

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[pending paid shipped cancelled] }
  validates :user_id, :payment_id, presence: true
end
