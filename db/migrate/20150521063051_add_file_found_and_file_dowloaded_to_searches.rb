class AddFileFoundAndFileDowloadedToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :file_found, :boolean
    add_column :searches, :file_downloaded, :boolean
  end
end
