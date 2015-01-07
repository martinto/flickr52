class ChangeTagsToText < ActiveRecord::Migration
  def change
    change_column :photos, :tags, :text
  end
end
