ActiveAdmin.register Order do

  permit_params :status, :sent_from_user_id, :sent_to_user_id, :parent_order_id

  index do
    selectable_column
    id_column
    column :status
    column 'Sent from user' do |order|
      link_to User.find(order.sent_from_user_id).email, admin_user_path(order.sent_from_user_id)
    end
    # column :user
    # column :user
    column 'Sent to user' do |order|
      link_to User.find(order.sent_to_user_id).email, admin_user_path(order.sent_to_user_id)
    end
    column 'Parent Order' do |order|
      next "" if order.parent_order_id.nil?
      link_to order.parent_order_id, admin_order_path(order.parent_order_id)
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :status
      f.input :sent_from_user_id, label: 'Sent from User', as: 'select', collection: User.all.map{|x| [x.email, x.id]}
      f.input :sent_to_user_id, label: 'Sent to User', as: 'select', collection: User.all.map{|x| [x.email, x.id]}
      f.input :parent_order_id, label: 'Parent Order', as: 'select',  collection: Order.select{|c| c[:id] != params[:id] }
    end
    f.actions
  end

  show do
    attributes_table do
      row :status
      row 'Sent from user' do |order|
        link_to order.sent_from_user_id, admin_user_path(order.sent_from_user_id)
      end       
      row 'Sent to user' do |order|
        link_to order.sent_to_user_id, admin_user_path(order.sent_to_user_id)
      end
      row 'Parent Order' do |order|
        next "" if order.parent_order_id.nil?
        link_to order.parent_order_id, admin_order_path(order.parent_order_id)
      end      
      # row :parent_order
    end
  end

  controller do
    def create
      if params[:order][:parent_order_id] == ""
        params[:order][:parent_order_id] = nil
      end
      super
    end

    def update
      if params[:order][:parent_order_id] == ""
        params[:order][:parent_order_id] = nil
      end
      super
    end  
  end
end
