class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /searches
  # GET /searches.json
  def index
    @searches = Search.order(:created_at)

    get_location
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @search = Search.find(params[:id])
    @search.search_for_statement

    @stock = Stock.find_by_ticker(@search.ticker)
    @purchase = Purchase.new
    @payment_plan = PaymentPlan.find_by_name("1.99")
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)
    @search.request_ip = request.remote_ip

    # Removed limit of downloads, as payments have been added
    if Search.where(["created_at > ? AND request_ip = ? AND file_downloaded = ?", 1.days.ago, request.remote_ip, true ]).size >= 3
      redirect_to "/later" and return
    end

    if @search.save
      https_switch
    else
      render :new
    end
  end

  def most_searched
    ss = Search.all
    @num_searches = ss.size
    @top_searches = hash_to_hist(ss.group_by{ |s| "#{s.ticker}_#{s.year}" }).first(10)

    @top_companies = hash_to_hist(ss.group_by{ |s| s.ticker }).first(10)
    @top_years = hash_to_hist(ss.group_by{ |s| s.year }).first(10)
  end


  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def https_switch
    if Rails.env.production?
      redirect_to "https://publicsecurities.herokuapp.com/searches/#{@search.id}", notice: 'Search was successfully created.',  :protocol => 'https://'
    else
      redirect_to @search,  notice: 'Search was successfully created.'
    end
  end


    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:ticker, :year, :filing )
    end

    def get_location
      # num of days back to update
      num = params[:num].to_i

      # which searches to update?
      searches_w_ip = Search.where(["created_at > ? AND request_ip IS NOT NULL", num.days.ago ])

      searches_w_ip.each do |s|
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
    end

    # map hash into a sorted historgram
    # sorted by value, highest first
    # histogram returned as a hash
    def hash_to_hist(hhash)
      hhash.map{ |k,v| [k, v.size] }.to_h.sort_by{|k,v| v}.reverse.to_h
    end

end
