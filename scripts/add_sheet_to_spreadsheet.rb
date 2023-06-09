# frozen_string_literal: true

require_relative '../lib/google/sheets'

test_sheet = Google::Sheets.new(file_id: 'test')
date = Date.today.next_month.strftime("%B %Y")
test_sheet.add_sheet_to_spreadsheet(date)
