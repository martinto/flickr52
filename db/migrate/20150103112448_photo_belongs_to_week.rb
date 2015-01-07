class PhotoBelongsToWeek < ActiveRecord::Migration
  def change
    add_column :photos, :week_id, :integer
  end
end
