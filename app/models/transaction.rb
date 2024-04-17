class Transaction < ApplicationRecord
  # This is to allow for the usage of the type column by disabling STI.
  # I don't understand what that is at this time. So we try stuff that sticks.
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :stock
end
