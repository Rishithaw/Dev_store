ActiveAdmin.register Product do

  controller do
    def self.ransackable_attributes(auth_object = nil)
      [
        "id", "name", "description", "base_price", "category_id",
        "stock_quantity", "product_type", "on_sale", "sale_price",
        "featured", "created_at", "updated_at"
      ]
    end

    def self.ransackable_associations(auth_object = nil)
      ["category"]
    end
  end

  filter :name
  filter :category
  filter :product_type
  filter :on_sale
  filter :created_at

  index do
    selectable_column
    id_column

    column :name
    column :category
    column :base_price

    column("Image") do |product|
      if product.image.attached?
        image_tag product.image.variant(resize_to_limit: [80, 80])
      else
        "No Image"
      end
    end

    column :product_type
    column :stock_quantity
    column :created_at

    actions defaults: true   #  View / Edit / Delete
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :category
      row :base_price
      row :sale_price
      row :on_sale
      row :product_type
      row :stock_quantity
      row :featured
      row :created_at
      row :updated_at

      row :image do |product|
        if product.image.attached?
          image_tag product.image.variant(resize_to_limit: [400, 400])
        else
          "No Image"
        end
      end
    end
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :category
      f.input :base_price
      f.input :on_sale
      f.input :sale_price
      f.input :stock_quantity
      f.input :product_type, as: :select, collection: ["physical", "digital"]
      f.input :featured

      # Active Storage image upload
      f.input :image, as: :file, hint: (
        f.object.image.attached? ?
          image_tag(f.object.image.variant(resize_to_limit: [120, 120])) :
          content_tag(:span, "No image uploaded yet")
      )
    end
    f.actions
  end

  permit_params :name, :description, :base_price, :sale_price, :on_sale,
                :stock_quantity, :product_type, :featured, :category_id,
                :image
end
