ActiveAdmin.register User do

  permit_params :email, :remember_created_at, :user_type_id, :warehouse_id, :password


  index do
    selectable_column
    id_column
    column :email
    # column :enabled
    # column :email_confirmed
    column 'User role' do | admin_user |
      admin_user.user_type.role if admin_user.user_type_id
    end
    column :warehouse
    actions
  end


  form do |f|
    f.inputs do
      f.input :email
      f.input :warehouse, required: false
      if f.object.new_record?
        f.input :password
      end
      if f.object.new_record? || current_admin_user.user_type.role == "super_admin"
        f.input :user_type_id, label: 'User role', as: 'select', collection: UserType.roles.keys.map{|x| [x, UserType.where(role: x)[0].id]}
      end      
      # f.input :email_confirmed
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :warehouse
      row :user_type_id do |user|
        user.user_type.role
      end
    end
  end
end
