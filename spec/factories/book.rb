# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.sentence }
    publish_date { Date.today - 1.year }
    author
  end
end
