require_relative 'Toggl'
require_relative 'date_time_helper'
require_relative 'Google/Calendar'

# TODO: Add unit tests.

def formatted_date(date)
  "#{date.year}-#{date.month}-#{date.day}"
end

def calendar_id
  File.read('.calendar_id.secret')
end

# TODO: helper, similar to the one in toggl.rb. Move everything to one place
def parse_date(date_string)
  date_elements = date_string.split('-')
  year = date_elements[0].to_i
  month = date_elements[1].to_i
  day = date_elements[2].to_i
  Time.new(year, month, day)
end

def build_calendar_entry_from_date(date_string)
  date_time = parse_date(date_string)
  puts "date_time = #{date_time}"

  process_timer(date_time)
end

# TODO: add a function to creat a week summary (total time logged) event on Monday morning
def build_calendar_entry_from_x_days_ago(days_ago)
  # TODO: move what should be in Toggl API to toggl file.
  puts "\ninitiating Toggl integration"

  time = Time.now
  one_day = 86400
  date_time = time - one_day * days_ago
  puts "date_time = #{date_time}"

  process_timer(date_time)
end

def build_weekly_summary(week_start_string, week_end_string)
  week_start = parse_date(week_start_string)
  week_end = parse_date(week_end_string)
  one_day = 86400
  next_week_start = week_end + one_day

  toggl = Toggl::Timer.new(formatted_date(week_start), formatted_date(week_end))
  toggl.print_config
  report = toggl.report_summary
  puts "\nBuilding the list of events"
  total_time_logged = report['total_grand']
  puts "total_time_logged = #{DateTimeHelper.readable_duration(total_time_logged)}"
  report_string = report['data'].map do |entry|
    "Project: #{entry['title']['project']}, client: #{entry['title']['client']}\n#{DateTimeHelper.readable_duration(entry['time'])}\n"
  end
  description = "Total time logged last week:\n#{DateTimeHelper.readable_duration(total_time_logged)}\n" + report_string.join("\n")
  [
    {
      start: "#{next_week_start.year}-#{next_week_start.month}-#{next_week_start.day}T06:04:59+02:00",
      end: "#{next_week_start.year}-#{next_week_start.month}-#{next_week_start.day}T06:09:59+02:00",
      title: "Last week summary",
      duration: 300000,
      description: description
    }
  ]
end

def process_timer(date_time)
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
      description: "Duration: #{DateTimeHelper.readable_duration(entry['dur'])}\nClient: #{entry['client']}\nProject: #{entry['project']}\nTotal time logged today: #{DateTimeHelper.readable_duration(total_time_logged)}",
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
prepared_entry_list = build_weekly_summary('2020-04-20', '2020-03-26')
prepared_entry_list = build_calendar_entry_from_x_days_ago(1)
# prepared_entry_list = build_calendar_entry_from_date('2020-03-30')
add_to_calendar(prepared_entry_list)
