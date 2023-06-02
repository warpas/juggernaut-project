# frozen_string_literal: true

require_relative '../lib/google/sheets'

test_sheet = Google::Sheets.new(file_id: 'test')
test_sheet.get_spreadsheet_values(range: 'Sheet1!A1:F14')

test_sheet.send_to_sheets(values: [['example']], range: 'Sheet1!B6')
values = [
  ['Rudolph', 'chimp', 9, 1300, 'black'],
  ['Susan', 'scorpion', 1, 80, 'red'],
  ['Paul', 'kwisatz haderach', 27, 1500, 'white'],
  ['Larry', 'spider', 0.5, 50, 'brown'],
  ['Gwendolyn', 'fish', 1, 10, 'blue'],
  ['Remington', 'lizard', 9, 100, 'green'],
  ['Leto', 'god emperor', 3467, 5000, 'grey'],
  ['Gregory', 'dog', 4, 700, 'black']
]
test_sheet.send_to_sheets(values: values, range: 'Sheet1!B7:F14')
test_sheet.get_spreadsheet_values(range: 'Sheet1!A1:F14')
