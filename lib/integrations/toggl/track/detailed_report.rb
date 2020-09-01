require_relative "../../../toggl/report"

module Integrations
  module Toggle # TODO: Change to Toggl
    module Track
      class DetailedReport
        attr_reader :start_date, :end_date, :time_entries

        def initialize(start_date:, end_date: start_date)
          @start_date = start_date
          @end_date = end_date
          @toggl_report ||= toggl_detailed_report
          @total_seconds = @toggl_report["total_grand"].to_s
        end

        def self.get_entries_for(date:)
          self.new(start_date: date).time_entries
        end

        private

        def toggl_detailed_report
          Toggl::Report.new(@start_date).report_details
        end
      end
    end
  end
end
