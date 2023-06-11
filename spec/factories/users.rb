FactoryBot.define do
  factory :user do
    name { "Bob"}
    password { "Bing123!"}
    sequence(:email) {|n| "exampleforbob#{n}@bing.com"}
  end
end