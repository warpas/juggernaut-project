require_relative "../integrations/toggl/track/context"

module Activities
  class TimeEntry
    attr_reader :started_at, :stopped_at, :description, :project, :client, :tags

    def initialize(some_data:, source: default_source)
      entry = source.first
    end

    def default_source(date: Date.today)
      # Integrations::Toggl::Track::Query.new
      Integrations::Toggl::Track.get_entries_for(date: date)
    end
  end
end
