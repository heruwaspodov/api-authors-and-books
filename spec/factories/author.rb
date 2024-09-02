# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    bio { Faker::Lorem.sentence }
    birthdate { Date.today - 20.year }
  end
end
