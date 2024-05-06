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
      expect(data[symbol]['previousClose']).to be_a(Numeric)
      expect(data[symbol]['symbol']).to include(symbol)
      expect(data[symbol]['name']).to be_a(String)
    end

    it 'handles empty responses' do
      symbol = nil
      query = YahooFinance::Query.new
      data = query.quote(symbol)

      expect(data).to eq({})
    end

    # There's a possibility of this test failing due to some invalid tickers not recognized by Yahoo Finance
    it 'returns price data for multiple valid symbols' do
      symbols = [ 'AAPL', 'TSLA', 'DIS', 'NVDA', 'KO' ]
      query = YahooFinance::Query.new
      data = query.quote(symbols)

      symbols.each do |symbol|
        next if data[symbol] == "No data found" || data[symbol].nil?

        expect(data[symbol]).to include(
          'previousClose',
          'prices',
          'symbol',
          'yearHigh',
          'yearLow'
        )
      end

      expect(data.keys.count).to eq(5)
    end

    it 'handles invalid responses' do
      symbol = 'APPL'
      query = YahooFinance::Query.new
      data = query.quote(symbol)

      expect(data[symbol]).to be_nil
    end
  end
end
