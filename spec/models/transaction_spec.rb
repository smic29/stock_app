require 'rails_helper'

RSpec.describe Transaction, type: :model do

  describe 'Concerns' do
    let(:user) { create(:user) }
    let(:unapproved_user) { create(:user, approved: false) }
    let(:stock) { create(:stock, user: user) }
    let(:transaction) { build(:transaction, user: user, stock: stock, type: 'Buy', price: 10, quantity: 1) }
    let(:invalid_transaction) { build(:transaction, user: unapproved_user, stock: stock, type: 'Buy', price: 10) }

    context 'when the user is approved' do
      it 'is valid' do
        expect(transaction).to be_valid
      end
    end

    context 'when the user is not approved' do
      it 'is not valid' do
        expect(invalid_transaction).not_to be_valid
        expect(invalid_transaction.errors[:user]).to include("Trades have not been approved yet")
      end
    end

    context 'when no user is provided' do
      let(:transaction) { build(:transaction, user: nil) }

      it 'is not valid' do
        expect(transaction).not_to be_valid
        expect(transaction.errors[:user]).to include("must exist")
      end
    end
  end

  describe 'Validations' do
    let(:user) { create(:user, cash: 1000) }
    let(:stock) { create(:stock, user: user, quantity: 10) }

    it { should validate_inclusion_of(:type).in_array(['Buy', 'Sell']).with_message(/is not a valid transaction type/) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }

    context 'when user has enough cash for a buy transaction' do
      it 'is valid' do
        transaction = build(:transaction, user: user, stock: stock, type: 'Buy', quantity: 5, price: 10)
        expect(transaction).to be_valid
      end
    end

    context 'when user does not have enough cash for a buy transaction' do
      it 'is not valid' do
        transaction = build(:transaction, user: user, stock: stock, type: 'Buy', quantity: 200, price: 10)
        expect(transaction).not_to be_valid
        expect(transaction.errors[:base]).to include('Insufficient cash balance for this transaction')
      end
    end

    context 'when user attempts to sell more stocks than currently owned' do
      it 'is not valid' do
        transaction = build(:transaction, user: user, stock: stock, type: 'Sell', quantity: 15, price: 10)
        expect(transaction).not_to be_valid
        expect(transaction.errors[:base]).to include('Cannot sell more stocks than currently owned')
      end
    end

    context 'when user attempts to sell stocks within the current quantity' do
      it 'is valid' do
        transaction = build(:transaction, user: user, stock: stock, type: 'Sell', quantity: 5, price: 10)
        expect(transaction).to be_valid
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:stock) }
  end

  describe 'Custom Methods' do
    describe 'self.transact' do
      let(:user) { create(:user) }
      let(:stock) { create(:stock, user: user) }
      let(:transaction_params) { { symbol: stock.symbol, price: 10, quantity: 5 } }

      context 'when committing a "Buy" transaction' do
        it 'creates a transaction and updates user and stock' do
          expect {
            Transaction.transact(user, 'Buy', transaction_params)
          }.to change(Transaction, :count).by(1)
          .and change(user, :cash).by(-50)
          .and change { stock.reload.quantity }.by(5)
        end
      end

      context 'when committing a "Sell" transaction' do
        before do
          user.update(cash: 1000)
          stock.update(quantity: 10)
        end

        it 'creates a transaction and updates user and stock' do
          expect {
            Transaction.transact(user, 'Sell', transaction_params)
          }.to change(Transaction, :count).by(1)
          .and change(user, :cash).by(50)
          .and change { stock.reload.quantity }.by(-5)
        end
      end

      context 'with invalid transaction params' do
        it 'raises an error' do
          expect {
            Transaction.transact(user, 'Buy', {})
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

end
