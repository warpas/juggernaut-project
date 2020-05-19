require_relative "requests"
require "json"

def connect_to_rescue_time(api_key_source:)
  file = File.read(api_key_source)
  JSON.parse(file)["api_key"]
end

key = connect_to_rescue_time(api_key_source: ".rt_apikey.secret.json")
puts key

base_path = "https://www.rescuetime.com/anapi/daily_summary_feed"
request_path = "#{base_path}/key=#{key}&format=json"

puts request_path
request_adapter = Requests::Adapter.new
result = request_adapter.get_request(request_path, [{}])
puts result
