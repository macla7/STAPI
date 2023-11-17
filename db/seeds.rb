# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create!(name: "Web Client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create!(name: "iOS Client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create!(name: "Android Client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create!(name: "React", redirect_uri: "", scopes: "")
end

fred = User.create(
  email: 'fred@bing.com',
  name: 'Fred Smith',
  password: 'Bing123!',
  password_confirmation: 'Bing123!',
  role: User.roles[:admin]
)

50.times do
  email = Faker::Internet.unique.email
  name = Faker::Name.name

  User.create(
    email: email,
    name: name,
    password: 'Bing123!',
    password_confirmation: 'Bing123!',
    role: User.roles[:user]
  )
end

business_names = [
  'Cardiovascular Institute',
  'Orthopedic Center',
  'Neurology Ward',
  'Maternity Suite',
  'Intensive Care Unit (ICU)',
]

business_names.each do |name|
  Group.create(
    name: name,
    temporary: false
  )
end

group_ids = Group.pluck(:id)
user_ids = User.pluck(:id)

# Assign Fred to each group as Admin
group_ids.each do |group_id|
  Membership.create(
    user_id: fred.id,
    group_id: group_id,
    role: 0,
    status: 0
  )
end

group_ids.each do |group_id|
  rand(1..20).times do
    user_id = user_ids.sample

    Membership.create(
      user_id: user_id,
      group_id: group_id,
      role: 1,
      status: 0
    )
  end
end