FactoryBot.define do
  factory :group do
    sequence(:name) {|n| "group number #{n}"}
  end
end
