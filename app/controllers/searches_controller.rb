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
    # change this to generate file
#    ContactMailer.welcome_email("publicsecurities@yahoo.com").deliver

    @search.search_for_statement
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


    if Search.where(["created_at > ? AND request_ip = ? AND file_downloaded = ?", 1.days.ago, request.remote_ip, true ]).size >= 3
      redirect_to "/later" and return
    end

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
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
          doc = Nokogiri::HTML(open(url))
          isp = " " + doc.css('table')[0].css('tr')[3].text.first(20)
          puts "isp is #{isp}"
          ip_data_tabel = doc.css('table')[1]
          str = ip_data_tabel.css('tr')[0..2].text
          puts "data is #{str}"
          str.slice!(/Latitude.*/)
          puts "sliced data is #{str}"
          location = str.gsub(/(Country:|State\/Region:|City:)/," ") + isp

        rescue
          location = "no-data"
        end
        s.update_attributes(ip_location: location)
      end
    end

end
