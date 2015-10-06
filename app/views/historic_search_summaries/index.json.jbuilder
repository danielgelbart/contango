json.array!(@historic_search_summaries) do |historic_search_summary|
  json.extract! historic_search_summary, :id, :start_date, :end_date, :num_searches, :num_downloads, :top_searches, :top_tickers, :top_years
  json.url historic_search_summary_url(historic_search_summary, format: :json)
end
