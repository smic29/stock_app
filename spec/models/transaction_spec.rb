require 'rails_helper'

RSpec.describe Transaction, type: :model do
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
        user.transactions.create(type: 'Buy', stock: stock, price: 10, quantity: 10)
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
