json.array!(@sent_emails) do |sent_email|
  json.extract! sent_email, :id, :photo, :sent_at, :error_type, :title
  json.url sent_email_url(sent_email, format: :json)
end
