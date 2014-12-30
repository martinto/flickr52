json.array!(@weeks) do |week|
  json.extract! week, :id, :week_number, :subject
  json.url week_url(week, format: :json)
end
