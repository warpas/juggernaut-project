require_relative 'Toggl'
require_relative 'Google/Calendar'

def readable_time(time)
  "5 hours, 17 minutes and 42 seconds"
end

def formatted_date(date)
  "#{date.year}-#{date.month}-#{date.day}"
end

def client_name
  File.read('.client_name.secret')
end

def project_name
  File.read('.project_name.secret')
end

def build_calendar_entry_from_x_days_ago(days_ago)
  puts "\ninitiating Toggl integration"

  time = Time.now
  one_day = 86400
  date_time = time - one_day * days_ago

  toggl = Toggl::Timer.new(formatted_date(date_time))
  toggl.print_config
  work_start_time = toggl.get_work_start_time(date_time)
  title = "Work for #{client_name}"
  duration = toggl.get_total_time
  total_work_time = toggl.get_total_work_time(date_time)
  human_readable_total_work_time = readable_time(total_work_time)
  description = "Time: #{human_readable_total_work_time}\nProject: #{project_name}"

  {
    start: work_start_time,
    duration: duration,
    title: title,
    description: description,
  }
end

def add_to_calendar(entry)
  puts "\ninitiating Google Calendar integration"
  calendar = Google::Calendar.new
  calendar.fetch_next_events(5)
  calendar.add_work_entry(entry)
end

prepared_entry = build_calendar_entry_from_x_days_ago(6)
add_to_calendar(prepared_entry)
