class AddFilenameToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :file_name, :string
  end
end
