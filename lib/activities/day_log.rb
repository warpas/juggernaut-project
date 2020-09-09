require_relative "../integrations/toggl/track/context"

module Activities
  class DayLog
    attr_reader :date, :entries

    def initialize(date:, tracker:)
      @date = date
      @entries = tracker.get_entries_for(date: date)
    end

    def client_list
      puts "entries = #{entries}"
    end
  end
end
