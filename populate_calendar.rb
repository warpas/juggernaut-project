require_relative "command_line"
require_relative "google/calendar"
require_relative "google/sheets"
require "json"

def copy_evens(date:, source_cal:, destination_cal:, color_coding:)
  source_calendar = Google::Calendar.new(config_file: "ds_credentials",
                                         token_file: "dsc_token",
                                         calendar_name: source_cal)
  destination_calendar = Google::Calendar.new(config_file: "ds_credentials",
                                              token_file: "dsc_token",
                                              calendar_name: destination_cal)
  source_calendar.copy_to_calendar(date: date, destination: destination_calendar, color_coding: color_coding)
end

cl_date = CommandLine.get_date_from_command_line(ARGV)
date = cl_date.empty? ? "2020-05-15" : cl_date

copy_evens(date: date, source_cal: "primary", destination_cal: "surykartka", color_coding: "")
copy_evens(date: date, source_cal: "color_coded", destination_cal: "surykartka", color_coding: "7")
