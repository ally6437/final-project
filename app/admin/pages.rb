ActiveAdmin.register Page do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :title, :content
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :content]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.inputs do
      f.input :title, input_html: { disabled: true } # Prevent editing the title
      f.input :content, as: :text
    end
    f.actions
  end

  # Remove unnecessary actions
  actions :all, except: [:destroy, :new]

  # Customize the index view
  index do
    selectable_column
    id_column
    column :title
    actions
  end
end
