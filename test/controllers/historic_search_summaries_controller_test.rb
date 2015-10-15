require 'test_helper'

class HistoricSearchSummariesControllerTest < ActionController::TestCase
  setup do
    @historic_search_summary = historic_search_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:historic_search_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create historic_search_summary" do
    assert_difference('HistoricSearchSummary.count') do
      post :create, historic_search_summary: { end_date: @historic_search_summary.end_date, num_downloads: @historic_search_summary.num_downloads, num_searches: @historic_search_summary.num_searches, start_date: @historic_search_summary.start_date, top_searches: @historic_search_summary.top_searches, top_tickers: @historic_search_summary.top_tickers, top_years: @historic_search_summary.top_years }
    end

    assert_redirected_to historic_search_summary_path(assigns(:historic_search_summary))
  end

  test "should show historic_search_summary" do
    get :show, id: @historic_search_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @historic_search_summary
    assert_response :success
  end

  test "should update historic_search_summary" do
    patch :update, id: @historic_search_summary, historic_search_summary: { end_date: @historic_search_summary.end_date, num_downloads: @historic_search_summary.num_downloads, num_searches: @historic_search_summary.num_searches, start_date: @historic_search_summary.start_date, top_searches: @historic_search_summary.top_searches, top_tickers: @historic_search_summary.top_tickers, top_years: @historic_search_summary.top_years }
    assert_redirected_to historic_search_summary_path(assigns(:historic_search_summary))
  end

  test "should destroy historic_search_summary" do
    assert_difference('HistoricSearchSummary.count', -1) do
      delete :destroy, id: @historic_search_summary
    end

    assert_redirected_to historic_search_summaries_path
  end
end
