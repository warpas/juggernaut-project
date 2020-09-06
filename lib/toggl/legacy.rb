require_relative "report"

module LegacyToggl
  class Report
    def initialize
    end

    def report_details(date:)
      Toggl::Report.new(date).report_details
    end
  end
end
