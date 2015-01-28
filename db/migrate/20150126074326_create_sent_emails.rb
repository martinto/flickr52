class CreateSentEmails < ActiveRecord::Migration
  def change
    create_table :sent_emails do |t|
      t.integer :photo_id
      t.datetime :sent_at
      t.string :error_type
      t.string :title

      t.timestamps
    end
  end
end
