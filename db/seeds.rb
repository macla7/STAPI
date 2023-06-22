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

400.times do
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
  'Cafe Supreme',
  'The Hungry Spoon',
  'Cinema Paradiso',
  'Tasty Bites Restaurant',
  'The Brew Hub',
  'Gourmet Delights',
  'The Food Junction',
  'The Movie House',
  'The Wanderlust Cafe',
  'Urban Eats',
  'Flicks and Food',
  'The Adventure Club',
  'The Roaming Fork',
  'Foodie Haven',
  'The Picture Palace',
  'The Traveler\'s Table',
  'Dine-In Delights',
  'The Wanderers Club',
  'Savor Cinema',
  'The Local Bistro',
  'The Excursion Cafe',
  'The Film Buffs',
  'The Sightseers Spot',
  'The Coffee Co-op',
  'The Tourist Tavern',
  'The Cinematic Experience',
  'Foodie Explorers',
  'The Journey Junction',
  'The Culinary Quest',
  'The Movie Munchies',
  'The Travelers Retreat',
  'The Fashion Emporium',
  'Trendy Threads',
  'The Stylish Boutique',
  'Chic Corner',
  'Fashionista Haven',
  'The Designer Outlet',
  'The Glamour Lounge',
  'The Chic Closet',
  'The Accessory Spot',
  'Trendsetter\'s Haven',
  'The Shoe Haven',
  'The Dapper Den',
  'The Glamorous Gallery',
  'The Jewelry Junction',
  'The Boutique Bazaar',
  'The Modish Mall',
  'The Vintage Vault',
  'The Stylistic Showcase',
  'The Fashion Fling',
  'The Couture Collection',
  'The Trendy Trunk',
  'The Foodie Haven',
  'The Movie Buffs',
  'The Wanderlust Group',
  'The Urban Retreat',
  'The Taste Trail',
  'The Sightseers Society',
  'The Fashion Fanatics',
  'The Stylish Squad',
  'The Adventure Seekers',
  'The Gourmet Gang',
  'The Film Fan Club',
  'The Travel Enthusiasts',
  'The Retail Rebels',
  'The Trend Setters',
  'The Culinary Connoisseurs',
  'The Movie Maniacs',
  'The Wanderers Guild',
  'The Fashion Forward',
  'The Foodie Fanatics',
  'The Explorers Club',
  'The Retail Royalty',
  'The Taste Explorers',
  'The Screen Stars',
  'The Style Seekers',
  'The Hungry Nomads',
  'The Sightseeing Squad',
  'The Trendy Tribe',
  'The Epicurean Ensemble',
  'The Film Fanatics',
  'The Journey Junkies',
  'The Retail Renegades',
  'The Culinary Crusaders',
  'The Movie Magic Society',
  'The Urban Adventurers',
  'The Fashionistas',
  'The Gastronomic Gurus',
  'The Sightseers Society',
  'The Chic Clique',
  'The Retail Revolutionaries',
  'The Taste Titans',
  'The Film Frenzy',
  'The Wanderlust Warriors',
  'The Trendy Troop',
  'The Foodie Force',
  'The Style Squad',
  'The Epicurean Explorers',
  'The Movie Moguls',
  'The Retail Rulers',
  'The Culinary Champions',
  'The Screen Savers',
  'The Urban Explorers',
  'The Fashion Forward',
  'The Gastronomy Gang'
]

business_names.shuffle.take(100).each do |name|
  Group.create(
    name: name
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
  rand(1..30).times do
    user_id = user_ids.sample

    Membership.create(
      user_id: user_id,
      group_id: group_id,
      role: 1,
      status: 0
    )
  end
end