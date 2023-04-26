class ApplicationController < ActionController::Base
  before_action :initialize_session
  helper_method :cart

  def initialize_session
    # this will initialize shopping cart
    session[:shopping_cart] ||= [] # empty array of product IDs
  end

  def cart
    Product.find(session[:shopping_cart]) # pass an array of ids and we get back a collection of products
  end

  helper_method :calculate_total_with_taxes
  def calculate_total_with_taxes(user, cart_items)
    cart_total = cart_items.sum { |item| item.quantity * item.product.price } # Calculate the cart total
    puts "Cart items: #{cart_items.inspect}"
    tax_rate = user.province.tax_rate # Get the tax rate from the user's province
    total_with_taxes = cart_total * (1 + tax_rate) # Calculate the total amount including taxes

    [cart_total, total_with_taxes]
  end
end
