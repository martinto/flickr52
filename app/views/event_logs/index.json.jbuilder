json.array!(@event_logs) do |event_log|
  json.extract! event_log, :id, :when, :message, :backtrace
  json.url event_log_url(event_log, format: :json)
end
