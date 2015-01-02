class AddFlickrDetailsToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :flickr_id, :string, :null => true
  end
end
