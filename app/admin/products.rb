ActiveAdmin.register Product do

  permit_params :name, :active, :slug, :price, :vat, :supplier_id, :unit

  index do
    selectable_column
    id_column
    column :name
    column :active
    column :slug
    column :price
    column :vat
    column :supplier
    column :unit

    column :created_at
    actions
  end

  filter :name
  filter :supplier
  filter :price
  filter :vat

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      f.input :slug
      f.input :price
      f.input :vat
      f.input :unit
      f.input :supplier_id, label: 'Supplier', as: 'select', collection: User.where(user_type_id: UserType.find_by(role: "supplier").id).map{|x| [x.email, x.id]}
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
      row :unit
      row :supplier
      row :created_at
    end
  end  
end
