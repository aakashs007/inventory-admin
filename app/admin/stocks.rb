ActiveAdmin.register Stock do

  permit_params :quantity, :product_id, :warehouse_id

  index do
    selectable_column
    id_column
    column :quantity
    # column :unit
    column :product
    column :warehouse
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :quantity
      # f.input :unit
      f.input :product
      f.input :warehouse
      # f.input :product_id, label: 'Product', as: 'select', collection: Product.all.map{|x| [x.name, x.id]}
    end
    f.actions
  end

  show do
    attributes_table do
      row :quantity
      # row :unit
      row :product
      row :warehouse
    end
  end  
end
