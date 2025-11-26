class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all

    # Start with all products, paginated
    @products = Product.order(created_at: :desc)

    # --- KEYWORD SEARCH ---
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @products = @products.where("name ILIKE ? OR description ILIKE ?", keyword, keyword)
    end

    # --- OPTIONAL CATEGORY FILTER ---
    if params[:search_category_id].present?
      @products = @products.where(category_id: params[:search_category_id])
    end

    # Paginate after filters applied
    @products = @products.page(params[:page]).per(12)
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted!"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :base_price, :image_url,
      :category_id, :stock_quantity, :product_type,
      :on_sale, :sale_price, :featured,
      :digital_file_url, :digital_file_size
    )
  end
end
