class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.date :year
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
