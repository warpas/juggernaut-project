require_relative "../libs/google/calendar"

calendar_object = Google::Calendar.new(calendar_name: "exercise")
list = calendar_object.list_calendars.select { |calendar|
  calendar[:name].start_with?("Exercise -")
}

list.each do |calendar|
  fetched = calendar_object.fetch_all_events(calendar[:id])
  fetched.items.each do |event|
    calendar_object.insert_calendar_event(event)
  end
end
