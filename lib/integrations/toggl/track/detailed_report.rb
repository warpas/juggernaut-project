require_relative "../../../toggl/legacy"
require_relative "time_entry"

module Integrations
  module Toggl
    module Track
      class DetailedReport
        attr_reader :start_date, :end_date, :time_entries, :recorded_seconds, :entries_count

        def initialize(start_date:, end_date: start_date, toggl_connection: LegacyToggl::Report.new)
          @start_date = start_date
          @end_date = end_date
          @toggl_raw_report ||= toggl_connection.report_details(date: @start_date)
          @recorded_seconds = @toggl_raw_report["total_grand"].to_i / 1000
          @entries_count = @toggl_raw_report["total_count"].to_i
          @time_entries = parse_entries(@toggl_raw_report)
        end

        def self.get_entries_for(date:)
          new(start_date: date).time_entries
        end

        private

        attr_reader :toggl_raw_report

        def parse_entries(report)
          report["data"].map { |entry|
            TimeEntry.new(entry.transform_keys(&:to_sym))
          }
        end
      end
    end
  end
end
