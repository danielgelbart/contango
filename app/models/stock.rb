# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  ticker     :string(255)
#  cik        :integer
#  fyed       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Stock < ActiveRecord::Base
end
