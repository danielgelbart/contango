class Search < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'

  def generate_link
    # NOTE - we don't even need the stock.cik since we can get this from the ticker and follow through the edgar site...

    # get search for 10-k search results page
    search_url = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{self.cik}&type=10-k&dateb=&owner=exclude&count=40"

    doc = Nokogiri::XML(open(search_url))

    # get acc number for relavent year
    doc.css('div#seriesDiv tr').each do |tr|

      # getting year based on asumption that filing date is
      # in calender year following report year for
      if tr.css('td')[4].text.first(4) == (self.year - 1).to_s
        acn = fling.xpath.acn
        break
      end
    end

    # check that we succesfully got acn

    # get file
    xl_url = "www.sec.gov/Archives/edgar/data/#{self.cik}/#{acn}/Financial_Report.xlsx"

    # save file?

    # how to transfer the link button?

  end



end
