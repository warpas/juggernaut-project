# frozen_string_literal: true

require_relative 'detailed_report'
require_relative 'summary_report'
require_relative 'time_entry'

module Integrations
  module Toggl
    module Track
      def self.get_entries_for(date:)
        Integrations::Toggl::Track::DetailedReport.get_entries_for(date: date)
      end

      def self.get_summary_for(date:, client:)
        Integrations::Toggl::Track::SummaryReport.get_summary_for(date: date, client: client)
      end
    end
  end
end
