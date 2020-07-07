require_relative "../libs/google/sheets"
require_relative "../libs/toggl/report"
require_relative "../date_time_helper"

def get_time_for(date: Date.today, category: "any")
  toggl = Toggl::Report.new(date)
  toggl.get_time_for(date: date, category: category)
end

def loop_for(days: 1)
  (1..days).each do |day|
    do_everything_once(date: (Date.today - day).to_s)
  end
end

def do_everything_once(date: (Date.today-1).to_s)
  trends_sheet = Google::Sheets.new(file_id: "trends")
  trends_sheet.get_spreadsheet_values(range: "Data!A:I")

  reading_time = get_time_for(date: date, category: "reading")
  writing_time = get_time_for(date: date, category: "writing")
  work_time = get_time_for(date: date, category: "work")
  games_time = get_time_for(date: date, category: "games")
  consumption_time = get_time_for(date: date, category: "consumption")
  creative_time = get_time_for(date: date, category: "creative")
  sleep_time = get_time_for(date: date, category: "sleep")
  exercise_time = get_time_for(date: date, category: "exercise")

  values = [
    [
      date,
      DateTimeHelper.sheets_duration_format(reading_time),
      DateTimeHelper.sheets_duration_format(writing_time),
      DateTimeHelper.sheets_duration_format(work_time),
      DateTimeHelper.sheets_duration_format(games_time),
      DateTimeHelper.sheets_duration_format(consumption_time),
      DateTimeHelper.sheets_duration_format(creative_time),
      DateTimeHelper.sheets_duration_format(sleep_time),
      DateTimeHelper.sheets_duration_format(exercise_time)
    ],
  ]

  # TODO: only append if the date is not already there
  # TODO: maybe update if the date is there but the values are different?
  trends_sheet.append_to_sheet(values: values, range: "Data!A:I")
  trends_sheet.get_spreadsheet_values(range: "Data!A:I")
end

# TODO: Modify this to ignore reported dates
# TODO: Split into 2 scripts
# loop_for(days: 60)
do_everything_once()
