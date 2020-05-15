module Toggl
  class GoogleCalendarAdapter
    # TODO: Add unit tests.

    def initialize
      puts "inside Toggl.GoogleCalendarAdapter.initialize"
      # @config = get_json_from_file("toggl/config.secret.json")
      # @api_token = api_token
      # @workspace_id = workspace_id
      # @start_date = start_date
      # @end_date = end_date.empty? ? start_date : end_date
      # @request_adapter = Requests::Adapter.new
      # @user_agent = get_user_email
    end

    def build_entry_list_from(detailed_report:)
      puts "\nBuilding the list of events"
      detailed_report["data"].map do |entry|
        {
          start: DateTime.parse(entry["start"]),
          end: DateTime.parse(entry["end"]),
          title: entry["description"],
          duration: entry["dur"],
          calendars_list: entry["tags"],
          description: "Duration: #{DateTimeHelper.readable_duration(entry["dur"])}\nClient: #{entry["client"]}\nProject: #{entry["project"]}\nTotal time logged today: #{DateTimeHelper.readable_duration(detailed_report["total_grand"])}\n\nDestination calendar: #{entry["tags"]}"
        }
      end
    end
  end
end
