# frozen_string_literal: true

require_relative '../lib/google/sheets'

test_sheet = Google::Sheets.new(file_id: 'test')
date = Date.today.next_month.strftime("%B %Y")
test_sheet.add_sheet_to_spreadsheet(date)
#TODO: How to find the last full column/row to decide range
last_month = test_sheet.get_spreadsheet_values(range: "#{Date.today.strftime("%B %Y")}!A1:AA50")
next_month = test_sheet.send_to_sheets(values: last_month.values, range:"#{date}!A1:AA50")
