ActiveAdmin.register Supplier do
  permit_params :name, :phone_number, :email, :address, :active

  index do
    selectable_column
    id_column
    column :name
    column :phone_number
    column :email
    column :address
    column :active
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :phone_number
      f.input :email
      f.input :address
      f.input :active
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :phone_number
      row :address
      row :active
      row :created_at
    end
  end
end
