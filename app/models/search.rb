# == Schema Information
#
# Table name: searches
#
#  id              :integer          not null, primary key
#  ticker          :string(255)
#  year            :integer
#  filing          :integer          default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  file_found      :boolean
#  file_downloaded :boolean
#  file_name       :string(255)
#  request_ip      :string(255)
#  ip_location     :string(255)
#

class Search < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'

  before_validation :uppercase_ticker

  validates :ticker, presence: { message: "Please type in a ticker symbol" }
  validates :ticker, inclusion: { in: Stock.all.map(&:ticker) << "", message: "Unknown ticker symbol. Please enter a different ticker symbol" }

  def uppercase_ticker
    self.ticker.upcase!
  end

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
      open("statements/#{filname}","wb") do |file|
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

    year_to_get = self.year + 1
    year_to_get = self.year if before_november(stock.fyed)
    puts "year to get is #{year_to_get}"

    filname = "#{ticker}_#{year}.xls"
    filname += "x" if year >= 2014

    success = false
    #check if file already exists
    if File.exist?( File.join(Rails.root,"statements",filname) )
      success = true
      puts "file Already exists and found!!!!"
    end


    if ! success
      # get search for 10-k search results page
      search_url = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{stock.cik}&type=10-k&dateb=&owner=exclude&count=40"
      acn = ""
      doc = Nokogiri::XML(open(search_url))
      puts search_url

      # get acc number for relavent year
      doc.css('div#seriesDiv tr').each do |tr|

        next if tr.css('td')[3].nil?
        puts "iterating over trs"
        # getting year based on asumption that filing date is
        # in calender year following report year for
        # unless fiscal_end_date < October

        if tr.css('td')[3].text.first(4) == (year_to_get).to_s
          puts "found correct string"
          acn_str = tr.css('td')[2].text
          acn = acn_str.partition("Acc-no: ").last.partition("(34").first.gsub("-","")
          puts "found acn #{acn}"
          break
        end
      end # getting acn for year

      # check that we succesfully got acn
      return handle_bad_return if (acn == "")

      xl_url = "http://www.sec.gov/Archives/edgar/data/#{stock.cik}/#{acn}/Financial_Report.xls"
      xl_url += "x" if year >= 2014

      success = download_to_local(xl_url,filname)
    end # download of report to local

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

  def before_november(fyed)
    return false if fyed.size < 2
    month = fyed.first(2).to_i
    return month < 11
  end





end
