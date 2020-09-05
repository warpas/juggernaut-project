require_relative "detailed_report"
require_relative "time_entry"

module Integrations
  module Toggl
    module Track
      def self.get_entries_for(date:)
        Integrations::Toggl::Track::DetailedReport.get_entries_for(date: date)
      end
    end
  end
end
