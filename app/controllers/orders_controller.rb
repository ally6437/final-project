class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
   puts "Inside the new action" # Add this line
   @order = current_user.orders.build
   #@cart_items = cart
   #cart_items_with_quantities = @cart_items.map { |item| OpenStruct.new(product: item, quantity: session[:shopping_cart].count(item.id)) }
   #@cart_total, @total_with_taxes = calculate_total_with_taxes(current_user, cart_items_with_quantities)
   @cart_items = current_user.cart ? current_user.cart.cart_items : []

   cart_items_with_quantities = @cart_items.map { |item| OpenStruct.new(product: item.product, quantity: item.quantity) }
   @cart_total, @total_with_taxes = calculate_total_with_taxes(current_user, cart_items_with_quantities)
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = current_user.orders.build(order_params)

    if params[:user] && params[:user][:address] && params[:user][:province_id]
      current_user.update(user_address_params)
    end

    if @order.save
      current_user.cart.cart_items.each do |item|
        order_item = @order.order_items.build(product: item.product, quantity: item.quantity, price: item.price)
        order_item.save
      end

      current_user.cart.cart_items.destroy_all
      redirect_to orders_path, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      #params.require(:order).permit(:user_id, :total, :status, :orderDate, :payment_id)
      params.require(:order).permit(:email, :address, :province_id, :total)
    end

    def get_user_address
      redirect_to edit_address_users_path if current_user.address.blank?
    end

    def user_address_params
      params.require(:user).permit(:address, :province_id)
    end

end
