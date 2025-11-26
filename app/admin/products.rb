ActiveAdmin.register Product do

  # Filters (optional)
  filter :name
  filter :category
  filter :product_type
  filter :on_sale
  filter :featured
  filter :created_at

  # Admin index table
  index do
    selectable_column
    id_column
    column :name
    column :base_price
    column :product_type
    column :category
    column :created_at
    actions   # View / Edit / Delete
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :base_price
      row :category
      row :product_type
      row :stock_quantity
      row :on_sale
      row :sale_price
      row :featured
      row :digital_file_url
      row :digital_file_size
      row :created_at
      row :updated_at
    end
  end

  # New/Edit form
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :base_price
      f.input :category
      f.input :product_type, as: :select, collection: ["physical", "digital"]
      f.input :stock_quantity
      f.input :on_sale
      f.input :sale_price
      f.input :featured
      f.input :digital_file_url
      f.input :digital_file_size
    end
    f.actions
  end
end
