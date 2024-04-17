class Transaction < ApplicationRecord
  # This is to allow for the usage of the type column by disabling STI.
  # I don't understand what that is at this time. So we try stuff that sticks.
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :stock

  before_validation :check_user_approved

  private

  def check_user_approved
    unless user.approved?
      errors.add(:user, "Trades have not been approved yet")
    end
  end
end
