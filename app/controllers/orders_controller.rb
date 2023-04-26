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
    #@order = Order.new
    @order = current_user.orders.build
    @total = calculate_total
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    #@order = Order.new(order_params)

    #respond_to do |format|
     # if @order.save
     #   format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
      #  format.json { render :show, status: :created, location: @order }
      #else
     #   format.html { render :new, status: :unprocessable_entity }
      #  format.json { render json: @order.errors, status: :unprocessable_entity }
     # end
   # end

   @order = current_user.orders.build(order_params)

   if @order.save
     # Save order_items from the cart to the order
     current_user.cart.cart_items.each do |item|
       order_item = @order.order_items.build(product: item.product, quantity: item.quantity, price: item.price)
       order_item.save
     end

     # Clear the user's cart
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

    # Calculate total price of items in the user's cart
    def calculate_total
      if current_user.cart
        current_user.cart.cart_items.sum(:price)
      else
        0
      end
    end
end
