# frozen_string_literal: true

require_relative '../lib/command_line'
require_relative '../lib/google/calendar'
require_relative '../lib/google/sheets'
require 'json'

def copy_events(date:, source_cal:, destination_cal:, color_coding:)
  source_calendar = Google::Calendar.new(
    config_file: 'lib/google/calendar/ds_credentials.secret.json',
    token_file: 'lib/google/calendar/dsc_token.secret.yaml',
    calendar_name: source_cal
  )
  destination_calendar = Google::Calendar.new(
    config_file: 'lib/google/calendar/ds_credentials.secret.json',
    token_file: 'lib/google/calendar/dsc_token.secret.yaml',
    calendar_name: destination_cal
  )
  result = source_calendar.copy_to_calendar(date: date, destination: destination_calendar, color_coding: color_coding)

  puts "\n📅  Events from #{source_calendar.name} copied successfully"
  result
end

puts "\n⌨️  Running populate_calendar script"
cl_date = CommandLineOldest.get_date_from_command_line(ARGV)
date = cl_date.empty? ? Date.today.to_s : cl_date

copy_events(date: date, source_cal: 'primary', destination_cal: 'destination', color_coding: '')
copy_events(date: date, source_cal: 'color_coded', destination_cal: 'destination', color_coding: '7')
