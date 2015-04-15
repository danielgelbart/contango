class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :ticker
      t.integer :cik
      t.string :fyed

      t.timestamps
    end
  end
end
