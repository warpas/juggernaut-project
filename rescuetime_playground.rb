require_relative "requests"
require_relative "google/calendar"
require "json"
require "date"

def connect_to_rescue_time(api_key_source:)
  file = File.read(api_key_source)
  JSON.parse(file)["api_key"]
end

def build_calendar_event(daily_summary:)
  puts "\nBuilding the daily summary event"
  description_lines = []
  daily_summary.keys.each do |key|
    # puts "key = #{key}"
    description_lines.push("#{key}: #{daily_summary[key]}") unless key == "id"
  end
  puts description_lines.join(",\n")
  [
    {
      start: DateTime.parse("#{daily_summary["date"]}T05:54:59+02:00"),
      end: DateTime.parse("#{daily_summary["date"]}T05:59:59+02:00"),
      title: "RescueTime daily summary",
      duration: 300000,
      description: description_lines.join(",\n")
    }
  ]
end

key = connect_to_rescue_time(api_key_source: ".rt_apikey.secret.json")
puts key

base_path = "https://www.rescuetime.com/anapi/"
daily_summary_feed_request_path = "#{base_path}daily_summary_feed?key=#{key}&format=json"

data_request_path = "#{base_path}data?key=#{key}&perspective=interval&restrict_kind=productivity&interval=hour&restrict_begin=2020-01-01&restrict_end=2020-01-01&format=json"

puts daily_summary_feed_request_path
request_adapter = Requests::Adapter.new
result = request_adapter.get_request(daily_summary_feed_request_path, [{}])
# puts result
# puts "\nresult['body'].to_json = #{result[:body].to_json}"
# puts result[:body]
parsed_response = JSON.parse(result[:body])
puts parsed_response
puts parsed_response.length
parsed_response.each do |daily_summary|
  puts daily_summary["date"]
end
report = parsed_response.first
puts report["date"]
calendar_event = build_calendar_event(daily_summary: report)
puts calendar_event

puts "\ninitiating Google Calendar integration"
calendar = Google::Calendar.new(config_file: "dw_credentials", token_file: "dwc_token")
calendar.fetch_next_events(5)
calendar.add_list_of_entries_no_duplicates(calendar_event)
