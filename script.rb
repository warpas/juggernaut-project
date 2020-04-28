require_relative "Toggl"
require_relative "date_time_helper"
require_relative "Google/Calendar"

# TODO: Add unit tests.

def build_calendar_entry_from_date(date_string)
  date_time = Time.parse(date_string)
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
  week_start = Time.parse(week_start_string)
  week_end = Time.parse(week_end_string)
  one_day = 86400
  next_week_start = week_end + one_day

  toggl = Toggl::Timer.new(week_start.strftime("%Y-%m-%d"), week_end.strftime("%Y-%m-%d"))
  toggl.print_config
  report = toggl.report_summary
  puts "\nBuilding the list of events"
  total_time_logged = report["total_grand"]
  puts "total_time_logged = #{DateTimeHelper.readable_duration(total_time_logged)}"
  report_string = report["data"].map { |entry|
    "Project: #{entry["title"]["project"]}, client: #{entry["title"]["client"]}\n#{DateTimeHelper.readable_duration(entry["time"])}\n"
  }
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
  toggl = Toggl::Timer.new(date_time.strftime("%Y-%m-%d"))
  toggl.print_config
  detailed_report = toggl.report_details

  puts "\nBuilding the list of events"
  total_time_logged = detailed_report["total_grand"]
  # TODO: handle report without entries
  detailed_report["data"].map do |entry|
    {
      start: entry["start"],
      end: entry["end"],
      title: entry["description"],
      duration: entry["dur"],
      description: "Duration: #{DateTimeHelper.readable_duration(entry["dur"])}\nClient: #{entry["client"]}\nProject: #{entry["project"]}\nTotal time logged today: #{DateTimeHelper.readable_duration(total_time_logged)}"
    }
  end
end

# TODO: change the way date is given. Ideally a GUI with a date picker. For now it could just be date given as a command line argument.
# prepared_entry_list = build_weekly_summary("2020-04-20", "2020-04-26")
prepared_entry_list = build_calendar_entry_from_x_days_ago(1)
# prepared_entry_list = build_calendar_entry_from_date('2020-03-30')

puts "\ninitiating Google Calendar integration"
calendar = Google::Calendar.new(config_file: "credentials", token_file: "token", calendar_name: "work")
calendar.fetch_next_events(5)
calendar.add_list_of_entries(prepared_entry_list)
