require_relative "../libs/command_line"
require_relative "../libs/toggl/report"
require_relative "../libs/toggl/time_entry"
require "date"

def includes_midnight?(entry, midnight)
  start = DateTime.parse(entry["start"])
  stop = DateTime.parse(entry["end"])
  (start..stop).cover? midnight
end

puts "\n⌨️  Running split_toggl_midnight_timers script"
# TODO: change the way date is given. Ideally a GUI with a date picker.
date = CommandLine.get_date_from_command_line(ARGV)

report_date =
  if date.empty?
    Date.today - 1
  else
    Date.parse(date) - 1
  end

puts report_date
puts date
toggl = Toggl::Report.new(report_date.to_s)
details = toggl.report_details
puts "details = \n#{details}"
midnight_date = report_date + 1
midnight = DateTime.new(midnight_date.year, midnight_date.month, midnight_date.day, 0, 0, 1, '+02:00')
puts "date = #{date}"
puts "report_date = #{report_date}"
puts "midnight = #{midnight}"
selection = details["data"].select do |entry|
  includes_midnight?(entry, midnight)
end

if selection.count == 1
  Toggl::TimeEntry.split(entry_to_split: selection.first, breakpoint: midnight.to_s)
elsif selection.empty?
  puts "No entries to split"
else
  puts "This is a weird situation. How is it possible that there are multiple entries to split?"
end
