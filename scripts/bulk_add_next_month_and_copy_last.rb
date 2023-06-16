
# frozen_string_literal: true

require_relative '../lib/google/sheets'

if ARGV.empty?
  puts "Please provide sheet credentials names to run the script for a list of partners"
  puts "eg. ruby scripts/bulk_add_next_month_and_copy_last.rb test test2"
else
  ARGV.each do |partner|
    begin
    test_sheet = Google::Sheets.new(file_id: partner)
    date = Date.today.next_month.strftime("%B %Y")
      puts "📅 Adding next months sheet for #{partner}..  📅"
    test_sheet.add_sheet_to_spreadsheet(date)
      puts "🔍  Pulling data from last months sheet.. 🔍"
    last_month = test_sheet.get_spreadsheet_values(range: Date.today.strftime("%B %Y"))
      puts "🏗  Populating data..  🏗"
    next_month = test_sheet.send_to_sheets(values: last_month.values, range: date)
      puts "✅  Completed for #{partner}  ✅"
      puts "\n-----------------------------------\n"
    rescue Google::Apis::ClientError
      puts "❌  INCOMPLETE: no #{partner} sheet defined, please verify your credentials.secret.json file in the sheets folder ❌"
    end
  end
end
