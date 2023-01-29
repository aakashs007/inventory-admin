ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :user_type_id

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column 'User role' do | admin_user |
      admin_user.user_type.role if admin_user.user_type_id
    end    
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :user_type_id
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      if f.object.new_record? || current_admin_user.user_type.role == "super_admin"
        f.input :user_type_id, label: 'User role', as: 'select', collection: UserType.roles.keys.map{|x| [x, UserType.where(role: x)[0].id]}
      end      
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :sign_in_count
      row :created_at
      row :user_type_id do |admin|
        admin_user.user_type.role
      end
    end
  end
end
