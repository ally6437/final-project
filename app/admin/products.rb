ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :name, :description, :price, :category_id, :image
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image, size: "150x150") : ""
    end
    f.actions
  end

  #form do |f|
  #  f.inputs "Product Details" do

   #   f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image, height: 100) : content_tag(:span, "No image yet")
  #  end
 #   f.actions
 # end

 # show do
  #  attributes_table do
      # ...
   #   row :image do |product|
   #     if product.image.attached?
   #       image_tag product.image, height: 100
    #   else
    #      "No image"
    #    end
    #  end
   # end
 #end

end
