require 'spec_helper'
require 'yahoo_finance'
require 'active_support/all'
require 'faker'

RSpec.describe YahooFinance::Query do
  describe '#quote' do
    it 'returns price data for a valid symbol' do
      symbol = Faker::Finance.ticker
      query = YahooFinance::Query.new
      data = query.quote(symbol)

      expect(data).to be_a(Hash)
      expect(data[symbol]).to include('prices')
      expect(data[symbol]['prices']).to be_a(Array)
      expect(data[symbol]['prices']).to include(data[symbol]['price'])
    end

    it 'handles empty responses' do
      symbol = nil
      query = YahooFinance::Query.new
      data = query.quote(symbol)

      expect(data).to eq({})
    end

    # There's a possibility of this test failing due to some invalid tickers not recognized by Yahoo Finance
    it 'returns price data for multiple valid symbols' do
      symbols = Array.new(5) { Faker::Finance.ticker }
      query = YahooFinance::Query.new
      data = query.quote(symbols)

      symbols.each do |symbol|
        expect(data).to include(symbol)
        expect(data[symbol]).to include('price')
      end
    end

    it 'handles responses with no prices' do
      symbol = 'APPL'
      query = YahooFinance::Query.new
      data = query.quote(symbol)

      expect(data[symbol]).not_to include('price')
      expect(data[symbol]).to include("Price history unavailable")
    end
  end
end
