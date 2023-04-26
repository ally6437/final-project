module ApplicationHelper
  def breadcrumbs
    crumbs = []

    # Home breadcrumb
    crumbs << link_to('Home', root_path)

    # Category breadcrumb (if applicable)
    if @category
      crumbs << link_to(@category.name, category_path(@category))
    end

    # Product breadcrumb (if applicable)
    if @product
      crumbs << link_to(@product.name, product_path(@product))
    end

    # Cart breadcrumb (if applicable)
    if @cart
      crumbs << link_to('Cart', carts_path)
    end

    # Order breadcrumb (if applicable)
    if @order
      crumbs << link_to('Order', orders_path)
    end

    # Render the breadcrumbs
    content_tag(:nav, class: 'breadcrumb is-medium') do
      crumbs.join(' ').html_safe
    end
  end
end
