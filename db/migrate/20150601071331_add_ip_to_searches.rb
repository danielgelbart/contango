class AddIpToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :request_ip, :string
    add_index :searches, :request_ip
    add_index :stocks, :ticker
  end
end
