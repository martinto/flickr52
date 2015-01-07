class ChangeOwnerIdToMemberId < ActiveRecord::Migration
  def change
    rename_column :photos, :owner_id, :member_id
  end
end
