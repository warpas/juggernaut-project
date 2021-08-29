# frozen_string_literal: true

# require_relative "../lib/interface/command_line"
# require "date"

def pick_priority_task(date: Date.today)
  todoist = Context::Todoist::Tasks.new
end

puts "\n⌨️  Running daily_priority script"

cli = Interface::CommandLineWithoutContext.new(args: ARGV)
date = cli.get_runtime_date(default: Date.today)

pick_priority_task(date: date)
