require_relative "command_line"
require_relative "toggl/report"
require_relative "toggl/google_calendar_adapter"
require_relative "google/calendar"
require 'date'

# TODO: Calculate week start and end based on a single date
def build_weekly_summary(week_start_string, week_end_string)
  week_start = Date.parse(week_start_string)
  week_end = Date.parse(week_end_string)
  toggl = Toggl::Report.new(week_start, week_end)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_weekly_summary_from(summary_report: toggl.report_summary, report_day: week_end + 1)
end

build_weekly_summary("2020-05-04", "2020-05-10")
puts "\ninitiating Google Calendar integration"
calendar = Google::Calendar.new(config_file: "dw_credentials", token_file: "dwc_token")
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
