class CartsController < ApplicationController
  #before_action :set_cart, only: %i[ show edit update destroy ]
  before_action :initialize_session
  before_action :load_cart

  # GET /carts or /carts.json
  def index
    @carts = Cart.all
    @total_amount = calculate_total
    @cart = current_user.cart
  end

  # GET /carts/1 or /carts/1.json
  def show
    @cart = Cart.find(params[:id])
  end

  def add_to_cart
    product_id = params[:product_id]
    @cart[product_id] = (@cart[product_id] || 0) + 1
    redirect_to carts_path, notice: "Product added to cart"
  end

  def remove_from_cart
    product_id = params[:product_id]
    @cart.delete(product_id)
    redirect_to carts_path, notice: "Product removed from cart"
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts or /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to cart_url(@cart), notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to cart_url(@cart), notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to carts_url, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # update quantity
  def update_quantity
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if quantity > 0
      @cart[product_id] = quantity
      redirect_to carts_path, notice: "Quantity updated"
    else
      @cart.delete(product_id)
      redirect_to carts_path, notice: "Product removed from cart"
    end
  end

  # order
  def proceed_to_order
    @cart = Cart.find(params[:id])
    @order = Order.new
    @order.user = current_user
    @cart.cart_items.each do |cart_item|
      @order.order_items.build(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.product.price)
    end
    @order.save
    redirect_to new_order_path(@order)
  end


  private

    def initialize_session
     session[:cart] ||= {}
     end

    def load_cart
      @cart = session[:cart]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:quantity, :total, :user_id)
    end

    # Calculate total amount in cart
    def calculate_total
      total = 0
      @cart.each do |product_id, quantity|
        product = Product.find(product_id)
        total += product.price * quantity
      end
      total
    end
end
