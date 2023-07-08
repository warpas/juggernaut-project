require_relative '../lib/google/sheets'

if ARGV.empty?
  puts "---------------------------------------\n Please provide sheet credentials names to run the script for a list of partners as listed in your credentials.secret.json file"
  puts "eg. ruby scripts/bulk_duplicate_last_month.rb test test2 \n ---------------------------------------"
else
  ARGV.each do |partner|
    begin
    sheet = Google::Sheets.new(file_id: partner)
    puts "📅 Preparing new summary sheet for #{partner}..  📅"
    puts "🔍  Setting correct month parameters 🔍"
    # If its before the 10th copy the month before last into a sheet named for last month,
    # otherwise it's last month sheet duplicating into sheet named for current month
    if Date.today.day < 5
      source_sheet_name = Date.today.prev_month.prev_month.strftime("%B %Y")
      new_sheet_name = Date.today.prev_month.strftime("%B %Y")
    else
      source_sheet_name = Date.today.prev_month.strftime("%B %Y")
      new_sheet_name = Date.today.strftime("%B %Y")
    end
    puts "🏗  Executing request data..  🏗"
    sheet.duplicate_sheet(new_sheet_name, source_sheet_name)
    puts "✅  Completed for #{partner}  ✅"
    puts "\n-----------------------------------\n"
    rescue Google::Apis::ClientError
      puts "❌  INCOMPLETE: no #{partner} sheet defined, please verify your credentials.secret.json file in the sheets folder ❌"
    end
  end
end
