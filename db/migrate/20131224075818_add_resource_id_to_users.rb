class AddResourceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :resource_id, :integer, default:0
  end
end
