# == Schema Information
#
# Table name: historic_search_summaries
#
#  id            :integer          not null, primary key
#  start_date    :date
#  days_duration :integer          default(7)
#  week_of_month :integer          default(1)
#  num_searches  :integer          default(0)
#  num_downloads :integer          default(0)
#  top_searches  :string(255)
#  top_tickers   :string(255)
#  top_years     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class HistoricSearchSummary < ActiveRecord::Base


  validates :start_date, uniqueness: true
  validates :days_duration, presence: true
  validates :num_searches, presence: true
  validates :num_downloads, presence: true
  validates :top_tickers, presence: true

  def end_date
    start_date + days_duration.days - 1
  end


  def tops_to_hash(sstring)
    # still need to remove '=' from matched regex
    sstring.split(",").map{ |s| [s.match(/[\d\w_]+ =/)[0],s.match(/= \d+/)[0]] }.to_h
  end

end
