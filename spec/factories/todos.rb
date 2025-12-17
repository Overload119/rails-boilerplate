# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    sequence(:title) { |n| "Todo item #{n}" }
    completed { false }
    sequence(:position) { |n| n }

    trait :completed do
      completed { true }
    end

    trait :active do
      completed { false }
    end
  end
end
