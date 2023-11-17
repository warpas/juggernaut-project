require_relative '../lib/google/calendar'

calendar_object = Google::Calendar.new(calendar_name: 'test')
fetched = calendar_object.fetch_events(Date.new(2023,7,12))
# p fetched
