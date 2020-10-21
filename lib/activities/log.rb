# frozen_string_literal: true

module Activities
  class Log
    attr_reader :entries

    def initialize(tracker_class: Integrations::Toggl::Track)
      @tracker = tracker_class
    end

    def list_for(date:)
      activities_list_raw = get_from_toggl(date: date)
      @entries = process(activities_list_raw)
      @entries
    end

    private

    attr_reader :tracker

    def get_from_toggl(date:)
      Integrations::Toggl.get_detailed_report(date: date)
    end

    # TODO: this name requires change
    def process(raw_report)
      Maintenance::Logger.log_info(message: raw_report)
      raw_report
    end
  end
end
