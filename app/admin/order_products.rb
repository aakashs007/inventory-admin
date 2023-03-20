ActiveAdmin.register OrderProduct do

  permit_params :serial_number, :order_id, :product_id, :model_number, :quantity, :unit

  index do
    selectable_column
    id_column
    column :serial_number
    column :model_number
    column :order
    column :product
    column :quantity
    column :unit
    actions
  end

  form do |f|
    f.inputs do
      f.input :serial_number
      f.input :model_number
      f.input :quantity
      f.input :unit
      # f.input :order
      f.input :order_id, label: 'Order id', as: 'select',  collection: Order.all.map{|x| [x.id]}
      f.input :product
    end
    f.actions
  end

  show do
    attributes_table do
      row :serial_number
      row :model_number
      row :order
      row :product
      row :quantity
      row :unit
    end
  end
end
