require_relative '../lib/google/sheets'

# Manually set which file_id this script should be performed
sheet = Google::Sheets.new(file_id: 'test')

# If its before the 10th copy the month before last into a sheet named for last month,
# otherwise it's last month sheet duplicating into sheet named for current month
if Date.today.day < 10
  source_sheet_name = Date.today.prev_month.prev_month.strftime("%B %Y")
  new_sheet_name = Date.today.prev_month.strftime("%B %Y")
else
  source_sheet_name = Date.today.prev_month.strftime("%B %Y")
  new_sheet_name = Date.today.strftime("%B %Y")
end

sheet.duplicate_sheet(new_sheet_name, source_sheet_name)
