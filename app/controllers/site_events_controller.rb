class SiteEventsController < ApplicationController
  before_action :set_site_event, only: [:show, :edit, :update, :destroy]

  # GET /site_events
  # GET /site_events.json
  def index
    @site_events = SiteEvent.order(:event_time).reverse
  end

  # GET /site_events/1
  # GET /site_events/1.json
  def show
  end

  # GET /site_events/new
  def new
    @site_event = SiteEvent.new
  end

  # GET /site_events/1/edit
  def edit
  end

  # POST /site_events
  # POST /site_events.json
  def create
    @site_event = SiteEvent.new(site_event_params)

    respond_to do |format|
      if @site_event.save
        format.html { redirect_to @site_event, notice: 'Site event was successfully created.' }
        format.json { render :show, status: :created, location: @site_event }
      else
        format.html { render :new }
        format.json { render json: @site_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_events/1
  # PATCH/PUT /site_events/1.json
  def update
    respond_to do |format|
      if @site_event.update(site_event_params)
        format.html { redirect_to @site_event, notice: 'Site event was successfully updated.' }
        format.json { render :show, status: :ok, location: @site_event }
      else
        format.html { render :edit }
        format.json { render json: @site_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_events/1
  # DELETE /site_events/1.json
  def destroy
    @site_event.destroy
    respond_to do |format|
      format.html { redirect_to site_events_url, notice: 'Site event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_event
      @site_event = SiteEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_event_params
      params.require(:site_event).permit(:event, :event_date)
    end
end
