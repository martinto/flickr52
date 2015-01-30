class AddBodyToSendEmails < ActiveRecord::Migration
  def change
    add_column :sent_emails, :body, :text
  end
end
