require_relative "../../../toggl/report"

module Integrations
  module Toggle # TODO: Change to Toggl
    module Track
      class DetailedReport
        def initialize(start_date:)
          @start_date = start_date
        end

        def self.get_entries_for(date:)
          instance = self.new(start_date: date)
          instance.detailed_report
        end

        def detailed_report # TODO: make it private
          Toggl::Report.new(@start_date).report_details
        end
      end
    end
  end
end
