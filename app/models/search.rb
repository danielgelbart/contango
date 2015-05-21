# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  ticker     :string(255)
#  year       :integer
#  filing     :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Search < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'

  def flip_x(string)
    if string.last == "x"
      return string.chop
    else
      return string+"x"
    end
  end


  def download_to_local(url,filname)
    begin
      report = open(url).read
    rescue
      url = flip_x(url)
      filname = flip_x(filname)
      begin
        report = open(url).read
      rescue
        return false
      end
    end
    puts "url is "+url
    puts "filname is "+filname
    if report.size > 0
      open("public/statements/#{filname}","wb") do |file|
           file << report
      end

      return true
    end
    return false
  end


  def search_for_statement
    # NOTE - we don't even need the stock.cik since we can get this from the ticker and follow through the edgar site...
    stock = Stock.find_by_ticker(self.ticker)

    return handle_bad_return if stock.nil?

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
    return handle_bad_return if (acn == "")

    xl_url = "http://www.sec.gov/Archives/edgar/data/#{stock.cik}/#{acn}/Financial_Report.xls"

    filname = "#{ticker}_#{year}.xls"

    if year >= 2014
      xl_url += "x"
      filname += "x"
    end

    success = false

    #check if file already exists
    if File.exist?( File.join(Rails.root,"public/statements",filname) )
      success = true
      puts "file found!!!!"
    end

    if (!success)
      success = download_to_local(xl_url,filname)
    end

    # handle file download
    if (success)
      puts "Success! should update the DB"
      update( file_found: true, file_name: filname)
      return true
    end

    # could not find file or download it
    return handle_bad_return
  end


  def handle_bad_return
    update_attribute( :file_found, false)
    return false
  end

end
