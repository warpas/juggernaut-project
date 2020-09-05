module Integrations
  module Toggl
    module Track
      class TimeEntry
        attr_reader :client, :project, :description, :tags, :duration, :start_time, :end_time

        def initialize(args)
          @project = args[:project]
          @client = args[:client]
          @start_time = args[:start_time]
        end
      end
    end
  end
end
