require_relative "command_line"
require_relative "toggl/report"
require_relative "toggl/google_calendar_adapter"
require_relative "date_time_helper"
require_relative "google/calendar"
require 'date'

# TODO: Add unit tests.

def build_calendar_entry_from(days_ago:)
  # TODO: move what should be in Toggl API to toggl file.
  date = Date.today - days_ago
  get_entry_list_for(date)
end

# TODO: Calculate week start and end based on a single date
def build_weekly_summary(week_start_string, week_end_string)
  week_start = Date.parse(week_start_string)
  week_end = Date.parse(week_end_string)
  toggl = Toggl::Report.new(week_start, week_end)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_weekly_summary_from(summary_report: toggl.report_summary, report_day: week_end + 1)
end

def get_entry_list_for(date)
  toggl = Toggl::Report.new(date)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_entry_list_from(detailed_report: toggl.report_details)
end

# def compare_goals_to_reality

# TODO: change the way date is given. Ideally a GUI with a date picker.
date = CommandLine.get_date_from_command_line(ARGV)

prepared_entry_list = if date.empty?
  # build_weekly_summary("2020-05-11", "2020-05-17")
  build_calendar_entry_from(days_ago: 1)
else
  get_entry_list_for(Date.parse(date))
end
puts "\ninitiating Google Calendar integration"
calendar = Google::Calendar.new(config_file: "dw_credentials", token_file: "dwc_token")
calendar.fetch_next_events(5)
# calendar.add_list_of_entries(prepared_entry_list)
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
