require_relative "../command_line"
require_relative "../toggl/report"
require_relative "../toggl/google_calendar_adapter"
require_relative "../google/calendar"
require "date"

# TODO: Add unit tests.

def build_calendar_entry_from(days_ago:)
  # TODO: move what should be in Toggl API to toggl file.
  date = Date.today - days_ago
  get_entry_list_for(date)
end

def get_entry_list_for(date)
  toggl = Toggl::Report.new(date)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_entry_list_from(report: toggl.report_details)
end

# def compare_goals_to_reality

puts "\n⌨️  Running send_toggl_to_calendar script"
# TODO: change the way date is given. Ideally a GUI with a date picker.
date = CommandLine.get_date_from_command_line(ARGV)

prepared_entry_list =
  if date.empty?
    build_calendar_entry_from(days_ago: 1)
  else
    get_entry_list_for(Date.parse(date))
  end

calendar = Google::Calendar.new
# TODO: Add or update, instead of just add.
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)