class AddUrlToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :flickr_url, :string
  end
end
