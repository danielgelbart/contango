json.array!(@searches) do |search|
  json.extract! search, :id, :ticker, :year, :filing
  json.url search_url(search, format: :json)
end
