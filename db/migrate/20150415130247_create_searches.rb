class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :ticker
      t.integer :year
      t.integer :filing, default:0

      t.timestamps
    end
  end
end
