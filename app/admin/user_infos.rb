ActiveAdmin.register UserInfo do

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :age
    column :latitude
    column :longitude
    column :phone_number
    column :user
    column :gender
    column :created_at
    actions
  end

  permit_params :first_name, :last_name, :age, :latitude, :longitude, :phone_number, :user_id, :gender

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :user_id, label: 'User', as: 'select', collection: User.all.map{|x| [x.email, x.id]}
      f.input :phone_number
      f.input :latitude
      f.input :longitude
      f.input :age
      f.input :gender
    end
    f.actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :user
      row :phone_number
      row :gender
      row :latitude
      row :longitude
      row :gender
    end
  end
end
