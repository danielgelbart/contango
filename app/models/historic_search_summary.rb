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



  def tops_to_hash(sstring)
    sstring.split(";").map{ |s| [s.match(/\w+/)[0],s.match(/\d+/)[0]] }.to_h
  end


end
