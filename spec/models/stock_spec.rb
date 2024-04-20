require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:user) { create(:user, approved: true) }
  let(:unapproved_user) { create(:user, approved: false) }

  describe "Validations" do
    it { should validate_presence_of(:symbol) }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
    it { should_not allow_value(nil).for(:user).with_message("Trades have not been approved yet") }
    puts "Stock: Validations Passed"
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:transactions) }
    puts "Stock: Associations Passed"
  end

  describe "Scopes" do
    describe ".displayable" do
      it "returns stocks associated with approved users and with quantity > 0" do
        approved_stock = create(:stock, user: user, quantity: 1)
        zero_quantity_stock = create(:stock, user: user, quantity: 0)

        expect(Stock.displayable).to include(approved_stock)
        expect(Stock.displayable).not_to include(zero_quantity_stock)
      end

      it "raises an error when associated user is not approved" do
        expect {
          create(:stock, user: unapproved_user, quantity: 1)
        }.to raise_error(ActiveRecord::RecordInvalid, /Trades have not been approved yet/)
      end
    end
    puts "Stock: Scopes Passed"
  end
end
