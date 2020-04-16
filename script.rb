require_relative 'Toggl'
require_relative 'Google/Calendar'

# TODO: Add unit tests.

def readable_time(time)
  # TODO: move parsing and other helpers to a different file.
  time_integer = time.to_i
  time_in_seconds = time_integer/1000
  hours = time_in_seconds/3600
  minutes_in_seconds = time_in_seconds % 3600
  minutes = minutes_in_seconds/60
  seconds = minutes_in_seconds % 60
  "#{hours} hours, #{minutes} minutes and #{seconds} seconds"
end

def formatted_date(date)
  "#{date.year}-#{date.month}-#{date.day}"
end

def calendar_id
  File.read('.calendar_id.secret')
end

# TODO: add a function to creat a week summary (total time logged) event on Monday morning
def build_calendar_entry_from_x_days_ago(days_ago)
  # TODO: move what should be in Toggl API to toggl file.
  puts "\ninitiating Toggl integration"

  time = Time.now
  one_day = 86400
  date_time = time - one_day * days_ago

  toggl = Toggl::Timer.new(formatted_date(date_time))
  toggl.print_config
  detailed_report = toggl.report_details

  puts "\nBuilding the list of events"
  total_time_logged = detailed_report['total_grand']
  # TODO: handle report without entries
  detailed_report['data'].map do |entry|
    {
      start: entry['start'],
      end: entry['end'],
      title: entry['description'],
      duration: entry['dur'],
      description: "Duration: #{readable_time(entry['dur'])}\nClient: #{entry['client']}\nProject: #{entry['project']}\nTotal time logged today: #{readable_time(total_time_logged)}",
    }
  end
end

def add_to_calendar(entry_list)
  # TODO: move what should be in calendar API to calendar file.
  puts "\ninitiating Google Calendar integration"
  # TODO: Add calendar id to config files
  calendar = Google::Calendar.new(calendar_id.strip)
  calendar.fetch_next_events(5)
  entry_list.each do |entry|
    calendar.add_work_entry(entry)
  end
end

# TODO: change the way date is given. Ideally a GUI with a date picker. For now it could just be date given as a command line argument.
prepared_entry_list = build_calendar_entry_from_x_days_ago(1)
add_to_calendar(prepared_entry_list)
