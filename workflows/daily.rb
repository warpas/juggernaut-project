require_relative "../libs/workflows/runner"

daily_scripts =
  [
    "scripts/split_toggl_midnight_timers.rb",
    "scripts/send_toggl_to_calendar.rb",
    "scripts/populate_calendar.rb",
    "scripts/daily_creative_report.rb",
    "scripts/daily_work_report.rb",
    "scripts/daily_trends_data_export.rb"
  ]

Workflows::Runner.new(scripts: daily_scripts).start
