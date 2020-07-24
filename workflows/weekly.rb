weekly_scripts =
  [
    "scripts/weekly_work_report.rb",
  ]

iterator = 1
script_count = weekly_scripts.count
weekly_scripts.each do |script|
  puts "\n⚙️  Running script number #{iterator} / #{script_count}\n"
  load script
  puts "\n✅  Script number #{iterator} / #{script_count} ran successfully\n"
  iterator += 1
end
puts "\n✅  All scripts within the workflow ran successfully!!"
