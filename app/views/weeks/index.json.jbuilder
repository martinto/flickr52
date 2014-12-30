json.array!(@weeks) do |week|
  json.extract! week, :id, :week_number, :subject
  json.url challenge_week_url(@challenge, week, format: :json)
end
