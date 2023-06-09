class ProductsController < ApplicationController
  before_action :set_categories

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    #@products = Product.joins(:category).where("products.name ILIKE ? OR categories.name ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    @products = Product.joins(:category).where("categories.name LIKE ? OR products.name LIKE ? OR products.description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
    render :index
  end

  def category
    @products = Product.where(category_id: params[:category_id]).paginate(page: params[:page], per_page: 10)
    render :index
  end

  private

  def set_categories
    @categories = Category.all
  end
end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id)
    end

