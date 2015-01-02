class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :flickr_id
      t.integer :challenge_id
      t.integer :owner_id
      t.string :secret
      t.integer :server
      t.integer :farm
      t.string :title
      t.boolean :is_public
      t.boolean :is_friend
      t.boolean :is_family
      t.datetime :date_added
      t.datetime :date_uploaded
      t.datetime :date_taken
      t.integer :date_taken_granularity
      t.string :tags

      t.timestamps
    end
  end
end
