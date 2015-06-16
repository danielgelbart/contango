class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :payment_plan_id
      t.integer :search_id

      t.timestamps
    end
  end
end
