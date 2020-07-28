require_relative "../libs/command_line"
require_relative "../libs/summaries/daily/trends"
require_relative "../libs/google/sheets"
require_relative "../libs/toggl/report"
require_relative "../date_time_helper"

def loop_for(days: 1)
  (1..days).reverse_each do |day|
    do_everything_once(date: (Date.today - day))
  end
end

def do_everything_once(date: (Date.today - 1))
  trends_sheet = Google::Sheets.new(file_id: "trends")

  toggl = Toggl::Report.new(date)
  values = Summaries::Daily::Trends.new(
    cumulative: toggl.report_summary,
    detailed: toggl.report_details
  ).build(date: date)

  # TODO: only append if the date is not already there
  # TODO: maybe update if the date is there but the values are different?
  trends_sheet.append_to_sheet(values: values, range: "Data!A:I")
  # trends_sheet.get_spreadsheet_values(range: "Data!A:I")
  puts "✅  Trend data appended for #{date}"
end

puts "\n⌨️  Running daily_trends_data_export script"

date = CommandLine.get_date_from_command_line(ARGV)

report_date =
  if date.empty?
    Date.today - 1
  else
    Date.parse(date) - 1
  end

# TODO: Modify this to ignore reported dates
# TODO: Split into 2 scripts
# loop_for(days: 60)
do_everything_once(date: report_date)
