class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :week_number
      t.string :subject
      t.integer :challenge_id

      t.timestamps
    end
  end
end
