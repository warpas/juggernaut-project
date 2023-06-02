require_relative '../lib/google/calendar'

calendar_object = Google::Calendar.new(calendar_name: 'primary')
p fetched = calendar_object.fetch_events(Date.today)
