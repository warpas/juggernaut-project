# frozen_string_literal: true

require_relative '../lib/command_line'
require_relative '../lib/toggl/report'
require_relative '../lib/toggl/google_calendar_adapter'
require_relative '../lib/google/calendar'
require 'date'

def build_daily_summary(date_string)
  date = Date.parse(date_string)
  toggl = Toggl::Report.new(date)
  adapter = Toggl::GoogleCalendarAdapter.new
  adapter.build_daily_summary_from(report: toggl.report_details, report_day: date, category: 'work')
end

puts "\n⌨️  Running daily_work_report script"
date = CommandLineOldest.get_date_from_command_line(ARGV)
puts "for the date of #{date}"

date_string =
  if date.empty?
    yesterday = Date.today - 1
    yesterday.to_s
  else
    date.to_s
  end
prepared_entry_list = build_daily_summary(date_string)

calendar = Google::Calendar.new
calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
