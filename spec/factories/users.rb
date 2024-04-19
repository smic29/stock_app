FactoryBot.define do
  factory :user do
    email { 'rspectester@email.com' }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.now }
    approved { true }
    admin { false }
    cash { 1000 }
  end
end
