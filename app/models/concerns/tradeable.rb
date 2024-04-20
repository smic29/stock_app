module Tradeable
  extend ActiveSupport::Concern

  included do
    before_validation :is_user_approved
  end

  private

  def is_user_approved
      errors.add(:user, "Trades have not been approved yet") unless user&.approved?
  end
end
