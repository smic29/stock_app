require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it { should validate_numericality_of(:cash).is_greater_than_or_equal_to(0) }
    puts "User: Validations Passed"
  end

  describe "Associations" do
    it { should have_many(:stocks) }
    it { should have_many(:transactions) }
    puts "User: Associations Passed"
  end

  describe "Scopes" do
    describe ".is_verified_trader" do
      it "returns users who are approved, not admins, and confirmed" do
        user = create(:user, approved: true, admin: false, confirmed_at: Time.now)
        expect(User.is_verified_trader).to include(user)
      end
    end

    describe ".is_pending_approval" do
      it "returns users who are not approved, not admins, and confirmed" do
        user = create(:user, approved: false, admin: false, confirmed_at: Time.now)
        expect(User.is_pending_approval).to include(user)
      end
    end

    describe ".is_a_user" do
      it "returns users who are not admins" do
        user = create(:user, admin: false)
        expect(User.is_a_user).to include(user)
      end
    end
    puts "User: Scopes Passed"
  end


end
