class CreateHistoricSearchSummaries < ActiveRecord::Migration
  def change
    create_table :historic_search_summaries do |t|
      t.date :start_date
      t.integer :days_duration, :default => 7
      t.integer :week_of_month, :default => 1
      t.integer :num_searches, :default => 0
      t.integer :num_downloads, :default => 0
      t.string :top_searches
      t.string :top_tickers
      t.string :top_years

      t.timestamps
    end

    add_index :historic_search_summaries, :start_date
  end
end
