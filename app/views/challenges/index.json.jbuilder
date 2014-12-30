json.array!(@challenges) do |challenge|
  json.extract! challenge, :id, :year, :title
  json.url challenge_url(challenge, format: :json)
end
