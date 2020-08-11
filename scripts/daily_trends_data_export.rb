require_relative "../libs/interface/command_line"
require_relative "../libs/toggl/report"
require_relative "../libs/analysis/daily_trends_report"
require_relative "../libs/google/sheets"

def loop_for(days: 1)
  (1..days).reverse_each do |day|
    do_everything_once(date: (Date.today - day))
  end
end

def do_everything_once(date: (Date.today - 1))
  trends_sheet = Google::Sheets.new(file_id: "trends")

  toggl = Toggl::Report.new(date)
  values = Analysis::DailyTrendsReport.new(
    cumulative: toggl.report_summary,
    detailed: toggl.report_details
  ).build(date: date)

  # TODO: only append if the date is not already there
  # TODO: maybe update if the date is there but the values are different?
  trends_sheet.append_to_sheet(values: values, range: "Data!A:I")
  # trends_sheet.get_spreadsheet_values(range: "Data!A:I")
  puts "📈  Trend data appended for #{date}"
end

puts "\n⌨️  Running daily_trends_data_export script"

cli = Interface::CommandLine.new(args: ARGV)
report_date = cli.get_runtime_date(default: Date.today) - 1

# TODO: Modify this to ignore reported dates
# TODO: Split into 2 scripts
# loop_for(days: 60)
do_everything_once(date: report_date)
