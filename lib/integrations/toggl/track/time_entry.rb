module Integrations
  module Toggl
    module Track
      class TimeEntry
        attr_reader :client, :project, :description, :tags, :duration, :start_time, :end_time

        def initialize(args)
          @project = args[:project]
          @client = args[:client]
          @description = args[:description]
          @duration = args[:dur]
          @tags = args[:tags]
          @start_time = args[:start]
          @end_time = args[:end]
        end
      end
    end
  end
end
