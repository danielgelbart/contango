# == Schema Information
#
# Table name: payment_plans
#
#  id         :integer          not null, primary key
#  price      :float
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PaymentPlan < ActiveRecord::Base
  validates :price, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :purchases

  def amount
    price.to_f / 100
  end


end
