require_relative "detailed_report"

module Integrations
  module Toggle # TODO: Change to Toggl
    module Track
      def self.get_entries_for(date:)
        # TODO: change Toggle to Toggl
        Integrations::Toggle::Track::DetailedReport.get_entries_for(date: date)
      end
    end
  end
end
