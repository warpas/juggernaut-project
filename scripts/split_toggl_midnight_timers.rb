# frozen_string_literal: true

require_relative '../lib/command_line'
require_relative '../lib/toggl/report'
require_relative '../lib/toggl/time_entry'
require_relative '../date_time_helper'
require 'date'

def includes_midnight?(entry, midnight)
  start = DateTime.parse(entry['start'])
  stop = DateTime.parse(entry['end'])
  (start..stop).cover? midnight
end

puts "\n⌨️  Running split_toggl_midnight_timers script"
# TODO: change the way date is given. Ideally a GUI with a date picker.
date = CommandLineOldest.get_date_from_command_line(ARGV)
puts "for the date of #{date}"

report_date =
  if date.empty?
    Date.today - 1
  else
    Date.parse(date) - 1
  end

toggl = Toggl::Report.new(report_date.to_s)
details = toggl.report_details
midnight = DateTimeHelper.get_next_midnight(report_date)
selection = details['data'].select do |entry|
  includes_midnight?(entry, midnight)
end

if selection.count == 1
  Toggl::TimeEntry.new(selection.first).split(breakpoint: midnight)
elsif selection.empty?
  puts '☑️   No entries to split'
else
  puts 'This is a weird situation. How is it possible that there are multiple entries to split?'
end
