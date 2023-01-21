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

User.first_or_create(email: 'mitch@bing.com',
  name: "Mitch Clark",
  password: 'Bing123!',
  password_confirmation: 'Bing123!',
  role: User.roles[:admin])
User.create(email: 'bob@bing.com',
  name: "Bob Jones",
  password: 'Bing123!',
  password_confirmation: 'Bing123!',
  role: User.roles[:user])
User.create(email: 'fred@bing.com',
  name: "Fred Smith",
  password: 'Bing123!',
  password_confirmation: 'Bing123!',
  role: User.roles[:user])
