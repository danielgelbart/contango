# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  payment_plan_id :integer
#  search_id       :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Purchase < ActiveRecord::Base
  belongs_to :payment_plan
  belongs_to :search
end
