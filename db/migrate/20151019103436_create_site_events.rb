class CreateSiteEvents < ActiveRecord::Migration
  def change
    create_table :site_events do |t|
      t.string :event
      t.date :event_time

      t.timestamps
    end
  end
end
