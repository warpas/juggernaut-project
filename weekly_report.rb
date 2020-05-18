require_relative "command_line"
require_relative "toggl/report"
require_relative "toggl/google_calendar_adapter"
require_relative "google/calendar"
require_relative "date_time_helper"
require 'date'

def build_weekly_summary(date_string)
  date = Date.parse(date_string)
  week_start = DateTimeHelper.get_week_start(date)
  week_end = DateTimeHelper.get_next_closest_sunday(date)
  toggl = Toggl::Report.new(week_start, week_end)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_weekly_summary_from(summary_report: toggl.report_summary, report_day: week_end + 1)
end

date = CommandLine.get_date_from_command_line(ARGV)

prepared_entry_list = if date.empty?
  last_week = Date.today - 7
  build_weekly_summary(last_week.to_s)
else
  build_weekly_summary(date)
end
puts "\ninitiating Google Calendar integration"
calendar = Google::Calendar.new(config_file: "dw_credentials", token_file: "dwc_token")
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
