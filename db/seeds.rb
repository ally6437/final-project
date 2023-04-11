
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb


CartItem.destroy_all
Cart.destroy_all
OrderItem.destroy_all
Order.destroy_all
Payment.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# Create categories
category_names = ['Roses', 'Lilies', 'Tulips', 'Daisies']

category_names.each do |name|
  Category.create(name: name)
end

# Create 100 products
100.times do
  product = Product.create(
    name: Faker::Flower.name,
    description: Faker::Lorem.sentence(word_count: 5),
    price: Faker::Commerce.price(range: 5.0..50.0),
    category_id: Category.pluck(:id).sample
  )
end

image_url = "https://source.unsplash.com/600x600/?flowers,#{product.name.downcase}"
product.image.attach(io: URI.open(image_url), filename: "#{product.name.parameterize}.jpg", content_type: 'image/jpeg')

puts "Created #{Category.count} categories."
puts "Created #{Product.count} products."

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Page.create(title: 'Contact', content: 'This is the contact page content.')
Page.create(title: 'About', content: 'This is the about page content.')