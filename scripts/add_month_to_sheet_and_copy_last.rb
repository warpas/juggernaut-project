# frozen_string_literal: true

require_relative '../lib/google/sheets'

test_sheet = Google::Sheets.new(file_id: 'test')
date = Date.today.next_month.strftime("%B %Y")
  puts "📅  Adding next months sheet  📅"
test_sheet.add_sheet_to_spreadsheet(date)
  puts "🔍  Pulling data from last months sheet.. 🔍"
last_month = test_sheet.get_spreadsheet_values(range: Date.today.strftime("%B %Y"))
  puts "🏗  Populating data..  🏗"
next_month = test_sheet.send_to_sheets(values: last_month.values, range: date)
  puts "✅  Completed  ✅"
  puts "\n-----------------------------------"
