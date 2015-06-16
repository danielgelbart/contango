json.array!(@purchases) do |purchase|
  json.extract! purchase, :id, :payment_plan_id, :search_id
  json.url purchase_url(purchase, format: :json)
end
