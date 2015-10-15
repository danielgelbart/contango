class HistoricSearchSummariesController < ApplicationController
  before_action :set_historic_search_summary, only: [:show, :edit, :update, :destroy]


  def index
    @historic_search_summaries = HistoricSearchSummary.all
  end

  def show
  end

  def new
    @historic_search_summary = HistoricSearchSummary.new
  end

  def create
    @historic_search_summary = HistoricSearchSummary.new(historic_search_summary_params)

    if @historic_search_summary.save
      redirect_to @historic_search_summary, notice: 'Historic search summary was successfully created.'
    else
      render :new
    end
  end

  def update
    if @historic_search_summary.update(historic_search_summary_params)
      redirect_to @historic_search_summary, notice: 'Historic search summary was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_historic_search_summary
      @historic_search_summary = HistoricSearchSummary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def historic_search_summary_params
      params.require(:historic_search_summary).permit(:start_date, :end_date, :num_searches, :num_downloads, :top_searches, :top_tickers, :top_years)
    end
end
