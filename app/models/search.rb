class Search < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'

  def download_to_local(url,filname)
    #what do we recieve here?
    open("public#{filname}","wb") do |file|
      file << open(url).read
    end
  end


  def generate_link
    # NOTE - we don't even need the stock.cik since we can get this from the ticker and follow through the edgar site...
    stock = Stock.find_by_ticker(self.ticker)

    return "--" if stock.nil?

    # get search for 10-k search results page
    search_url = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{stock.cik}&type=10-k&dateb=&owner=exclude&count=40"

    doc = Nokogiri::XML(open(search_url))

    puts search_url
    acn = ""
    # get acc number for relavent year
    doc.css('div#seriesDiv tr').each do |tr|

      next if tr.css('td')[3].nil?
      puts "iterating over trs"
      # getting year based on asumption that filing date is
      # in calender year following report year for
      if tr.css('td')[3].text.first(4) == (self.year + 1).to_s
        puts "found correct string"
        acn_str = tr.css('td')[2].text
        acn = acn_str.partition("Acc-no: ").last.partition("(34").first.gsub("-","")
        puts "fournd acn #{acn}"
        break
      end
    end

    # check that we succesfully got acn
    return "--" if (acn == "")

    xl_url = "http://www.sec.gov/Archives/edgar/data/#{stock.cik}/#{acn}/Financial_Report.xlsx"

    filname = "/statements/#{ticker}_#{year}.xlsx"
    download_to_local(xl_url,filname)

    return filname
  end
end
