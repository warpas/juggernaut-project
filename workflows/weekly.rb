require_relative "../libs/workflows/runner"

weekly_scripts =
  [
    "scripts/weekly_work_report.rb"
  ]

Workflows::Runner.new(scripts: weekly_scripts).start
