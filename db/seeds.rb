
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb


require 'csv'

CartItem.destroy_all
Cart.destroy_all
OrderItem.destroy_all
Order.destroy_all
Payment.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all
Province.destroy_all

provinces = [
  { name: 'British Columbia', tax_rate: 12.0 },
  { name: 'Alberta', tax_rate: 5.0 },
  { name: 'Saskatchewan', tax_rate: 11.0 },
  { name: 'Manitoba', tax_rate: 12.0 },
  { name: 'Ontario', tax_rate: 13.0 },
  { name: 'Quebec', tax_rate: 14.975 },
  { name: 'New Brunswick', tax_rate: 15.0 },
  { name: 'Nova Scotia', tax_rate: 15.0 },
  { name: 'Prince Edward Island', tax_rate: 15.0 },
  { name: 'Newfoundland and Labrador', tax_rate: 15.0 },
  { name: 'Yukon', tax_rate: 5.0 },
  { name: 'Northwest Territories', tax_rate: 5.0 },
  { name: 'Nunavut', tax_rate: 5.0 }
]

provinces.each do |province|
  Province.create!(province)
end


csv_text = File.read(Rails.root.join('db', 'flowers.csv'))
csv = CSV.parse(csv_text, headers: true)

csv.each do |row|
  category = Category.find_or_create_by(name: row['Flower group'])
  product = Product.create(
    name: row['Flower name'],
    description: row['Description'],
    price: Faker::Commerce.price(range: 5.0..50.0),
    category: category
  )
  match = product.name.match(/(\w+)\s*\((\w+)/)
  if match
    first_word, bracket_word = match.captures
    keywords = "#{first_word},#{bracket_word}"
    image_url = "https://source.unsplash.com/600x600/?#{keywords}"
    product.image.attach(io: URI.open(image_url), filename: "#{product.name.parameterize}.jpg", content_type: 'image/jpeg')
  else

    image_url = "https://source.unsplash.com/600x600/?flowers,#{product.name.downcase.gsub(' ', '-')}"
    product.image.attach(io: URI.open(image_url), filename: "#{product.name.parameterize}.jpg", content_type: 'image/jpeg')
end
end

puts "Created #{Category.count} categories."
puts "Created #{Product.count} products."

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Page.create(title: 'Contact', content: 'This is the contact page content.')
Page.create(title: 'About', content: 'This is the about page content.')
