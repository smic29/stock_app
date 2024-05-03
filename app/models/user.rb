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

  after_create_commit -> {
    broadcast_replace_later_to "admin_dashboard_stream",
    target: "admin_user_component",
    partial: "admin/dashboard/users_component"
  }
end
