namespace :searches do

  desc "Create historic searches summaries
   0 == use all searches since last summary, exlude partial week
   1 == use all searches since last summary until NOW
   2 == use all searches in DB, exclude partial week
"

  task :sum, [:mode]  => :environment do |task,args|

    mode = args[:mode]
    span = 7 #!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 7
    hss = HistoricSearchSummary.order("start_date").last #newest
    b_point = "1980-02-01".to_date
    b_point = hss.end_date unless hss.nil?
    ss = Search.where(["created_at > ?", b_point]).sort_by{ |s| s.created_at }

    ss = Search.all.sort_by{ |s| s.created_at } if mode == 2

    #splitt ss into the relavnet ordered groups
    #a hash { date=>[,,] , date=> [s,s,s,s]}
    ss_g_by_date = ss.group_by{ |s| s.created_at.to_date }

    #an array of theses: [ [date,[s,s,s,s,,]] , [date,[s,s,s,s,]] ]
    # where each element represents exactly 'span' such dates
    ssg = ss_g_by_date.each_slice(span).to_a

    (ssg.pop if ssg.last.size < span) unless mode == 1

    begin
    puts "Last search date for sumarizing is #{ssg.last.last[0]}"
    catch
      puts "Could not print last search date for sumary"
    end
    #for each group, create a new record
    # g is an array of size 'span' (i.e there are exatly 'span' dates in each elemtns of g
    # each element in g is of the form: [ [date,[s,s,s,s,,]] , [date,[s,s,s,s,]] ]
    ssg.each do |g|

      nhr = HistoricSearchSummary.new
      nhr.start_date = g.first[0]
      #nhr.end_date = g.last[0]
      nhr.days_duration = (g.last[0] - g.first[0]).to_i + 1
      nhr.week_of_month = (g.first[0].day / 7) + 1

      next if !check_overlap(nhr)

      # unit all searches from group into single array
      sarr = []
      g.each do |gd|
        sarr += gd[1]
      end

      nhr.num_searches  = sarr.size

      num_downs = 0
      sarr.each do |s|
        num_downs+= 1 if s.file_downloaded
      end
      nhr.num_downloads = num_downs

      nhr.top_searches=hash_to_string(sarr.group_by{|s|"#{s.ticker}_#{s.year}"})
      nhr.top_tickers = hash_to_string(sarr.group_by{ |s| "#{s.ticker}" })
      nhr.top_years = hash_to_string(sarr.group_by{ |s| "#{s.year}" })

      if nhr.save
        puts "Added historic record summary ending #{ g.last[0]}"
      end
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

  def hash_to_string(hhash)
    hhash.map{ |k,v| [k, v.size] }.to_h.sort_by{|k,v| v}.reverse.to_h.first(5).map{|k,v| "#{k} = #{v}"}.join(' , ')
  end

  def check_overlap(nr)
    ors = HistoricSearchSummary.all.order("start_date")
    ors.each do |ol|
      return false if (ol.start_date..ol.end_date).include? nr.start_date
    end
    return true
  end
end
