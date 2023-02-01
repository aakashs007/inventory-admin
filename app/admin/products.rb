ActiveAdmin.register Product do

  permit_params :name, :active, :slug, :price, :vat, :supplier_id

  index do
    selectable_column
    id_column
    column :name
    column :active
    column :slug
    column :price
    column :vat
    column :supplier
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      f.input :slug
      f.input :price
      f.input :vat
      f.input :supplier
      # f.input :supplier_id, label: 'Supplier', as: 'select', collection: Supplier.all.map{|x| [x.name, x.id]}
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :active
      row :slug
      row :price
      row :vat
      row :supplier
      row :created_at
    end
  end  
end