class RemoveRedundantDatabaseFields < ActiveRecord::Migration
  def change
    remove_column :photos, :server
    remove_column :photos, :farm
    remove_column :photos, :is_friend
    remove_column :photos, :is_family
    remove_column :members, :icon_server
    remove_column :members, :icon_farm
  end
end
