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
end
