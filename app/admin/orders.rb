ActiveAdmin.register Order do

  permit_params :status, :sent_from_user_id, :sent_to_user_id, :parent_order_id, :transfer_type, :order_type, :payment_mode, :issued_for_client_name, :issued_for_client_address, :issued_for_client_pincode, :service_report_number, :delievery_challan_number, :sent_at, :recieved_at, :issued_to_warehouse_id

  index do
    selectable_column
    id_column
    column :status
    column :transfer_type
    column :order_type
    column :payment_mode
    column 'Sent from user' do |order|
      link_to User.find(order.sent_from_user_id).email, admin_user_path(order.sent_from_user_id)
    end
    column 'Sent to user' do |order|
      next "" if order.sent_to_user_id.nil?
      link_to User.find(order.sent_to_user_id).email, admin_user_path(order.sent_to_user_id)
    end
    column 'Parent Order' do |order|
      next "" if order.parent_order_id.nil?
      link_to order.parent_order_id, admin_order_path(order.parent_order_id)
    end
    column 'Issued to warehouse' do |order|
      next "" if order.issued_to_warehouse_id.nil?
      link_to Warehouse.find(order.issued_to_warehouse_id).name, admin_warehouse_path(order.issued_to_warehouse_id)
    end
    column :issued_for_client_name
    column :issued_for_client_address
    column :issued_for_client_pincode
    column :service_report_number
    column :delievery_challan_number
    column :sent_at
    column :recieved_at

    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :status
      f.input :transfer_type
      f.input :order_type
      f.input :payment_mode      
      f.input :sent_from_user_id, label: 'Sent from User', as: 'select', collection: User.all.map{|x| [x.email, x.id]}
      f.input :sent_to_user_id, label: 'Sent to User', as: 'select', collection: User.all.map{|x| [x.email, x.id]}
      f.input :parent_order_id, label: 'Parent Order', as: 'select',  collection: Order.select{|c| c[:id] != params[:id] }
      f.input :issued_to_warehouse_id, label: 'Issued to warehouse', as: 'select',  collection: Warehouse.all
      f.input :issued_for_client_name
      f.input :issued_for_client_address
      f.input :issued_for_client_pincode
      f.input :service_report_number
      f.input :delievery_challan_number
      f.input :sent_at, as: :datetime_picker
      f.input :recieved_at, as: :datetime_picker
    end
    f.actions
  end

  show do
    attributes_table do
      row :status
      row :transfer_type
      row :order_type
      row :payment_mode
      row 'Sent from user' do |order|
        link_to order.sent_from_user_id, admin_user_path(order.sent_from_user_id)
      end       
      row 'Sent to user' do |order|
        next "" if order.sent_to_user_id.nil?
        link_to order.sent_to_user_id, admin_user_path(order.sent_to_user_id)
      end
      row 'Parent Order' do |order|
        next "" if order.parent_order_id.nil?
        link_to order.parent_order_id, admin_order_path(order.parent_order_id)
      end
      row 'Issued to warehouse' do |order|
        next "" if order.issued_to_warehouse_id.nil?
        link_to Warehouse.find(order.issued_to_warehouse_id).name, admin_user_path(order.issued_to_warehouse_id)
      end      
      # row :issued_to_warehouse_id
      row :issued_for_client_name
      row :issued_for_client_address
      row :issued_for_client_pincode
      row :service_report_number
      row :delievery_challan_number
      row :sent_at
      row :recieved_at
    end
  end

  controller do
    def update
      if params[:order][:parent_order_id] == ""
        params[:order][:parent_order_id] = nil
      end
      super
    end  
  end
end
