require_relative "../integrations/toggl/track/context"

module Activities
  class DayLog
    attr_reader :date, :entries

    def initialize(date:)
      @date = date
      @entries = Integrations::Toggle::Track.get_entries_for(date: date)
    end
  end
end
