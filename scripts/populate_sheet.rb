require_relative "../lib/google/calendar"
require_relative "../lib/google/sheets"
require "json"

def build_row(date:, source_calendar:)
  events = source_calendar.fetch_events(date)
  # TODO: use color coding here
  # color_dictionary = {}
  [date, events.count]
end

def send_list_to_sheets(destination_file:, destination_sheet:, range:, row_list:)
  # destination_file.get_spreadsheet_values(range: "#{destination_sheet}!#{range}")
  destination_file.send_to_sheets(values: row_list, range: "#{destination_sheet}!#{range}")
end

def add_timestamp(destination_file:, destination_sheet:, cell:)
  timestamp = [[Time.now.strftime("%Y-%m-%d %H:%M:%S")]]
  destination_file.send_to_sheets(values: timestamp, range: "#{destination_sheet}!#{cell}")
end

calendar = Google::Calendar.new
file = Google::Sheets.new(file_id: "test")
sheet = "Sheet2"
range = "B1:G35"
cell = "I1"

row_list = []

# TODO: smarter cycle through days of month
(1..31).each do |day|
  # TODO: connect date and sheet name for this case
  date = "2020-06-#{day}"
  split = date.split("-").map(&:to_i)
  date_is_valid = Date.valid_date?(split[0], split[1], split[2])

  if date_is_valid
    row_list << build_row(date: date, source_calendar: calendar)
  else
    puts "#{date} is not a valid date"
  end
end
puts "Rows sent to Google Sheets 📤\n#{row_list}"
send_list_to_sheets(destination_file: file, destination_sheet: sheet, range: range, row_list: row_list)
add_timestamp(destination_file: file, destination_sheet: sheet, cell: cell)

# add_timestamp(destination_file: file, destination_sheet: sheet)
# build_row("2020-05-05", 5)
