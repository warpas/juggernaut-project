require_relative "../libs/command_line"
require_relative "../libs/toggl/report"
require_relative "../libs/toggl/google_calendar_adapter"
require_relative "../libs/google/calendar"
require_relative "../date_time_helper"
require "date"

def build_weekly_summary(date_string)
  date = Date.parse(date_string)
  week_start = DateTimeHelper.get_week_start(date)
  week_end = DateTimeHelper.get_next_closest_sunday(date)
  toggl = Toggl::Report.new(week_start, week_end)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_weekly_summary_from(report: toggl.report_details, report_day: week_end + 1, category: "work")
end

def last_week_date
  Date.today - 7
end

def date
  cl_date = CommandLine.get_date_from_command_line(ARGV)
  return last_week_date if cl_date.empty?
  cl_date
end

prepared_entry_list = build_weekly_summary(date.to_s)

puts "\ninitiating Google Calendar integration"
calendar = Google::Calendar.new
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
