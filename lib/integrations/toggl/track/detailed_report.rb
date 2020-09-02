require_relative "../../../toggl/legacy"

module Integrations
  module Toggl
    module Track
      class DetailedReport
        attr_reader :start_date, :end_date, :time_entries

        def initialize(start_date:, end_date: start_date, toggl_adapter: LegacyToggl::Report.new)
          @start_date = start_date
          @end_date = end_date
          @toggl_raw_report ||= toggl_adapter.report_details(date: @start_date)
          @total_seconds = @toggl_raw_report["total_grand"].to_s
          @time_entries = @toggl_raw_report
        end

        def self.get_entries_for(date:)
          self.new(start_date: date).time_entries
        end
      end
    end
  end
end
