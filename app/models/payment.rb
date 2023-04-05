class Payment < ApplicationRecord
  belongs_to :order

  validates :status, inclusion: { in: %w[pending paid refunded] }
  validates :order_id, presence: true
end
