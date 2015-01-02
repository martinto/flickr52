class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :nsid
      t.string :username
      t.integer :icon_server
      t.integer :icon_farm
      t.integer :member_type
      t.string :real_name
      t.string :email

      timestamps = t.timestamps
      timestamps
    end

    create_table :challenges_members, id: false do |t|
      t.belongs_to :challenge, index: true
      t.belongs_to :member, index: true
    end
  end
end
