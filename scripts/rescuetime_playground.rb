require_relative '../lib/requests'
require_relative '../lib/google/calendar'
require 'json'
require 'date'

def connect_to_rescue_time(api_key_source:)
  file = File.read(api_key_source)
  JSON.parse(file)['api_key']
end

def build_calendar_event(daily_summary:)
  description_lines = []
  daily_summary.keys.each do |key|
    # puts "key = #{key}"
    description_lines.push("#{key}: #{daily_summary[key]}") unless key == 'id'
  end
  {
    start: DateTime.parse("#{daily_summary['date']}T05:30:01+02:00"),
    end: DateTime.parse("#{daily_summary['date']}T05:35:01+02:00"),
    title: 'RescueTime daily summary',
    duration: 300_000,
    description: description_lines.join(",\n")
  }
end

key = connect_to_rescue_time(api_key_source: '.rt_apikey.secret.json')

base_path = 'https://www.rescuetime.com/anapi/'
daily_summary_feed_request_path = "#{base_path}daily_summary_feed?key=#{key}&format=json"

data_request_path = "#{base_path}data?key=#{key}&perspective=interval&restrict_kind=category&resolution_time=minute&interval=hour&restrict_begin=2020-05-23&restrict_end=2020-05-23&format=json"

puts daily_summary_feed_request_path
request_adapter = Requests::Adapter.new
result = request_adapter.get_request(daily_summary_feed_request_path, [{}])
result_data = request_adapter.get_request(data_request_path, [{}])
parsed_data = JSON.parse(result_data[:body])
# puts "result_data = #{parsed_data}"
row_headers = parsed_data['row_headers']
# puts "result_data_rows = #{parsed_data["rows"]}"
parsed_data['rows'].each do |row|
  # puts "data row = #{row}"
  row_hash = {}
  row.each_with_index.map do |element, index|
    key = row_headers[index]
    row_hash[key] = element
  end
  puts row_hash
  # TODO: group these entries by categories and add bigger categories to Google Calendar
end

parsed_response = JSON.parse(result[:body])
prepared_entry_list = parsed_response.map do |daily_summary|
  build_calendar_event(daily_summary: daily_summary)
end

calendar = Google::Calendar.new
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
