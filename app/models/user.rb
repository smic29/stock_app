class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  validates :cash, numericality: { greater_than_or_equal_to: 0 }

  scope :is_verified_trader, -> { where(approved: true, admin: false).where.not(confirmed_at:nil) }
  scope :is_pending_approval, -> { where(approved: false, admin: false).where.not(confirmed_at:nil) }
  scope :is_a_user, -> { where(admin: false) }

  has_many :stocks
  has_many :transactions
end
