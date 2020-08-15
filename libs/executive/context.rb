require_relative "reporter"

module Executive
  class Context
    def self.generate_weekly_work_report
      Executive::Reporter.generate_weekly_work_report
    end

    def self.send_activities_to_calendar
    end
  end
end
