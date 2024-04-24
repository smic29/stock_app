class Stock < ApplicationRecord
  include Tradeable

  belongs_to :user
  has_many :transactions

  validates :symbol, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :displayable, -> { joins(:user).merge(User.is_verified_trader).where("quantity > ?", 0 ) }
  scope :not_zero, -> { where("quantity > ?", 0) }

end
