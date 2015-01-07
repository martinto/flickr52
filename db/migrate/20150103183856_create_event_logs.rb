class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.datetime :when
      t.string :message
      t.text :backtrace

      t.timestamps
    end
  end
end
