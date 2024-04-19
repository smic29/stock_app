FactoryBot.define do
  factory :stock do
    symbol { Faker::Finance.ticker }
  end
end
