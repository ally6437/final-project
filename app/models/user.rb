class User < ApplicationRecord
  belongs_to :cart
  has_many :orders

  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 6 }
  validates :first_name, :last_name, :phone_number, :address, presence: true
end
