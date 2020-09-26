# frozen_string_literal: true

require_relative 'runner'

module Workflows
  class Daily
    def self.run
      Workflows::Runner.new(scripts: daily_scripts).start
    end

    def self.tasks
      daily_scripts
    end

    def self.daily_scripts
      [
        'scripts/split_toggl_midnight_timers.rb',
        'scripts/send_toggl_to_calendar.rb',
        'scripts/populate_calendar.rb',
        'scripts/daily_creative_report.rb',
        'scripts/daily_work_report.rb',
        'scripts/daily_trends_data_export.rb',
        'scripts/get_important_tasks.rb'
      ]
    end

    private_class_method :daily_scripts
  end
end
