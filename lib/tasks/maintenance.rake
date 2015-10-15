namespace :searches do

  desc "Create historic searches summaries"
  task :sum, [:start,:end,:span]  => :environment do |task,args|

    #date format is "yyyy-mm-dd"


    span = 7

    b_point = "1980-02-01".to_date
    hss = HistoricSearchSummary.order("start_date").last #newest

    b_point = hss.end_date unless hss.nil?
    ss = Search.where(["created_at > ?", b_point]).sort_by{ |s| s.created_at }

    #splitt ss into the relavnet ordered groups
    #a hash { date=>[,,] , date=> [s,s,s,s]}
    ss_g_by_date = ss.group_by{ |s| s.created_at.to_date }

    #an array of theses: [ [date,[s,s,s,s,,]] , [date,[s,s,s,s,]] ]
    # where each element represents exactly 'span' such dates
    ssg = ss_g_by_date.each_slice(span).to_a
    ssg.pop if ssg.last.size < span

    #for each group, create a new record
    # g is an array of size 'span' (i.e there are exatly 'span' dates in each elemtns of g
    # each element in g is of the form: [ [date,[s,s,s,s,,]] , [date,[s,s,s,s,]] ]
    ssg.each do |g|

      nhr = HistoricSearchSummary.new
      nhr.start_date = g.first[0]
      nhr.days_duration = (g.last[0] - g.first[0]).to_i
      nhr.week_of_month = (g.first[0].day / 7) + 1
      #  num_searches  :integer          default(0)

      #  num_downloads :integer          default(0)

      #  top_searches  :string(255)
      #  top_tickers   :string(255)
      #  top_years     :string(255)


    end #group g
  end

  desc "Remove searches that are older than 'num' days old"
  task :remove_old, [:num] => :environment do |task, args|
    days_ago = args[:num].to_i.days.ago
    Search.where(["created_at < ?", days_ago]).map(&:destroy)
  end


  desc "Translate ip address into geographical location for all seraches"
  task :geolocate => :environment do

    Search.all.each do |s|
      ip = s.request_ip
      url = "http://whatismyipaddress.com/ip/#{ip}"

      begin
        puts "Going to get url #{url}"
        doc = Nokogiri::HTML(open(url))
        isp = " " + doc.css('table')[0].css('tr')[4].text.first(25)
        ip_data_tabel = doc.css('table')[1]
        str = ip_data_tabel.css('tr')[1..3].text
        puts "isp is #{isp}"

        puts "data is #{str}"
        str.slice!(/Latitude(\n|.)*/)
        puts "Sliced data is #{str}"
        location = str.gsub(/(Country:|State\/Region:|City:)/," ") + isp

      rescue
        location = "no-data"
      end

      s.update_attributes(ip_location: location)
    end

  end #geolocate



end
