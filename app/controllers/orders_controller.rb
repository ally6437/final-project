class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    #@orders = Order.all
    @order = Order.new
    @tax_rate = calculate_tax_rate
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    #@order = Order.new(order_params)

    #respond_to do |format|
      #if @order.save
      #  format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
      #  format.json { render :show, status: :created, location: @order }
     # else
      #  format.html { render :new, status: :unprocessable_entity }
      #  format.json { render json: @order.errors, status: :unprocessable_entity }
     # end
    #end
    @order = Order.new(user: current_user)

  subtotal = current_user.cart.subtotal
  @tax_rate = calculate_tax_rate
  tax = subtotal * @tax_rate

  @order.total = subtotal + tax

  # Add any other necessary fields for the order, such as payment_id, status, etc.

  if @order.save
    # Add the order_items from the cart to the order
    current_user.cart.cart_items.each do |cart_item|
      OrderItem.create!(
        order: @order,
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end

    # Clear the cart after the order is placed
    current_user.cart.cart_items.destroy_all

    redirect_to order_path(@order), notice: 'Order was successfully created.'
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
      params.require(:order).permit(:user_id, :total, :status, :orderDate, :payment_id)
    end

    #calculate tax rate
    def calculate_tax_rate
      # Define the tax rates for each province
      tax_rates = {
        "ON" => 0.13,
        "MB" => 0.12,
        "AB" => 0.05,

      }

      user_province = current_user.province
      tax_rates[user_province] || 0
    end
end
