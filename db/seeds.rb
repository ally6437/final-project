
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

  image_url = row['url']
  temp_image = Down.download(image_url)
  product.image.attach(io: File.open(temp_image.path), filename: "#{product.name.parameterize}.jpg", content_type: 'image/jpeg')
  temp_image.close
  temp_image.unlink
end

puts "Created #{Category.count} categories."
puts "Created #{Product.count} products."

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Page.create(title: 'Contact', content: 'This is the contact page content.')
Page.create(title: 'About', content: 'This is the about page content.')
