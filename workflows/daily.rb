daily_scripts =
  [
    "scripts/split_toggl_midnight_timers.rb",
    "scripts/send_toggl_to_calendar.rb",
    "scripts/populate_calendar.rb",
    "scripts/daily_creative_report.rb",
    "scripts/daily_work_report.rb",
    "scripts/daily_trends_data_export.rb"
  ]

iterator = 1
script_count = daily_scripts.count
daily_scripts.each do |script|
  puts "\n⚙️  Running script number #{iterator} / #{script_count}\n"
  load script
  puts "\n✅  Script number #{iterator} / #{script_count} ran successfully\n"
  iterator += 1
end
puts "\n✅  All scripts within the workflow ran successfully!!"
