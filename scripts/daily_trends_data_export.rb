require_relative "../libs/google/sheets"
require_relative "../libs/toggl/report"

def get_time_for(date: Date.today, category: "any")
  toggl = Toggl::Report.new(date)
  toggl.get_time_for(date: date, category: category)
end

def do_everything(date: (Date.today-2).to_s)
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
      reading_time,
      writing_time,
      work_time,
      games_time,
      consumption_time,
      creative_time,
      sleep_time,
      exercise_time
    ],
  ]

  trends_sheet.append_to_sheet(values: values, range: "Data!A:I")
  trends_sheet.get_spreadsheet_values(range: "Data!A:I")
end

do_everything()
