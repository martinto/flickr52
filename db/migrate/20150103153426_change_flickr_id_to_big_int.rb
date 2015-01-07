class ChangeFlickrIdToBigInt < ActiveRecord::Migration
  def change
    change_column :photos, :flickr_id, :bigint
  end
end
