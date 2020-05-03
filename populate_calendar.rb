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
  events = source_calendar.fetch_events(date)

  events.each do |event|
    entry = {
      start: event.start.date_time,
      end: event.end.date_time,
      title: event.summary
    }
    if color_coding != "" && event.color_id == color_coding
      destination_calendar.add_entry(entry)
    elsif color_coding == ""
      destination_calendar.add_entry(entry)
    end
  end
end

date = "2020-05-4"
copy_evens(date: date, source_cal: "primary", destination_cal: "surykartka", color_coding: "")
copy_evens(date: date, source_cal: "color_coded", destination_cal: "surykartka", color_coding: "7")
