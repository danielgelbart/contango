class CreatePaymentPlans < ActiveRecord::Migration
  def change
    create_table :payment_plans do |t|
      t.integer :price
      t.string :name
      t.timestamps
    end
  end
end
