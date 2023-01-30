class ChangeIdsToUuidsInExistingTables < ActiveRecord::Migration[7.0]
  def up
    generate_uuid = lambda { SecureRandom.uuid }

    change_column :users, :id, :string, primary_key: true, default: generate_uuid.call, null: false
    change_column :admin_users, :id, :string, primary_key: true, default: generate_uuid.call, null: false
  end

  def down
    change_column :users, :id, :string
    change_column :admin_users, :id, :string
  end
end
