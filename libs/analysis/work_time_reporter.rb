require_relative "../toggl/report"
require_relative "../../date_time_helper"
require "date"

module Analysis
  class WorkTimeReporter
    def self.build_report_for_today
      reporter = WorkTimeReporter.new
      reporter.build_report(date: Date.today)
    end

    def build_report(date:)
      client_name = "Client"
      toggl = Toggl::Report.new(date)

      filtered_report = toggl.report_summary["data"].select do |category|
        category["title"]["client"] == client_name
      end
      time_list = filtered_report.map do |category|
        category["time"]
      end
      time_in_milliseconds = time_list.sum

      formatted_time = DateTimeHelper.readable_duration(time_in_milliseconds)
      puts formatted_time
    end
  end
end
