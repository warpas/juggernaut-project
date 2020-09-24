# frozen_string_literal: true

require_relative 'report'

module LegacyToggl
  class Report
    def initialize; end

    def report_details(date:)
      Toggl::Report.new(date).report_details
    end

    def report_summary(date:)
      Toggl::Report.new(date).report_summary
    end
  end
end
