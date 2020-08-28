module Activities
  class Log
    def list_for(date:)
      activities_list_raw = get_from_toggl(date: date)
      activities_list = process(activities_list_raw)
    end

    private

    def get_from_toggl(date:)
      Integrations::Toggl.get_detailed_report(date: date)
    end

    # TODO: this name requires change
    def process(raw_report)
      Maintenance::Logger.log_info(message: raw_report)
    end
  end
end
