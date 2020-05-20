require_relative "requests"
require "json"

def connect_to_rescue_time(api_key_source:)
  file = File.read(api_key_source)
  JSON.parse(file)["api_key"]
end

key = connect_to_rescue_time(api_key_source: ".rt_apikey.secret.json")
puts key

base_path = "https://www.rescuetime.com/anapi/"
daily_summary_feed_request_path = "#{base_path}daily_summary_feed?key=#{key}&format=json"

data_request_path = "#{base_path}data?key=#{key}&perspective=interval&restrict_kind=productivity&interval=hour&restrict_begin=2020-01-01&restrict_end=2020-01-01&format=json"

puts daily_summary_feed_request_path
request_adapter = Requests::Adapter.new
result = request_adapter.get_request(daily_summary_feed_request_path, [{}])
puts result
