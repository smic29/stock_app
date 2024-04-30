class TickerGenerator
  def self.generate_samples(count)
    samples = []

    while samples.length < count do
      ticker = Faker::Finance.ticker

      unless samples.include?(ticker)
        samples << ticker
      end
    end

    samples
  end

  def self.generate_ticker_scroll(count)
    symbols = []
    count.times do
      symbol = Faker::Finance.ticker
      price = Faker::Number.decimal(l_digits: 2)
      symbols << [symbol, price]
    end

    symbols
  end
end
