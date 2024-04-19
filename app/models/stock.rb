class Stock < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :symbol, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validate :user_approved

  scope :displayable, -> { joins(:user).merge(User.is_verified_trader).where("quantity > ?", 0 ) }

  private

  def user_approved
    errors.add(:user, "must be approved") unless user&.approved?
  end
end
