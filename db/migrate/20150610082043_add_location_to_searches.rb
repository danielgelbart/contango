class AddLocationToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :ip_location, :string
  end
end
