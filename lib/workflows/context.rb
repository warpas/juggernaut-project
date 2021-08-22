require_relative 'daily'
require_relative 'weekly'

module Workflows
  def self.run_daily_workflow
    Workflows::Daily.run
  end

  def self.run_weekly_workflow
    Workflows::Weekly.run
  end
end
