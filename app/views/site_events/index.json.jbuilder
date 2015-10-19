json.array!(@site_events) do |site_event|
  json.extract! site_event, :id, :event, :event_date
  json.url site_event_url(site_event, format: :json)
end
