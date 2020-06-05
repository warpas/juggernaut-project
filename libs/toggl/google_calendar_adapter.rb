module Toggl
  require_relative "../../date_time_helper"
  class GoogleCalendarAdapter
    # TODO: Add unit tests.

    def initialize
      puts "inside Toggl.GoogleCalendarAdapter.initialize"
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

    # TODO: rebuild it to use daily summary, at least partially
    def build_weekly_summary_from(summary_report:, report_day:)
      puts "\nBuilding the weekly summary event"
      total_time_logged = DateTimeHelper.readable_duration(summary_report["total_grand"])
      report_string = summary_report["data"].map { |entry|
        "\nProject: #{entry["title"]["project"]}, client: #{entry["title"]["client"]}\n#{DateTimeHelper.readable_duration(entry["time"])}\n"
      }
      [
        {
          start: DateTime.parse("#{report_day.year}-#{report_day.month}-#{report_day.day}T06:04:59+02:00"),
          end: DateTime.parse("#{report_day.year}-#{report_day.month}-#{report_day.day}T06:09:59+02:00"),
          title: "Last week summary",
          duration: 300000,
          calendars_list: ["work"],
          description: "Total time logged last week:\n#{total_time_logged}\n" + report_string.join("\n")
        }
      ]
    end

    def build_daily_summary_from(summary_report:, report_day:)
      puts "\nBuilding the daily summary event"
      total_time_logged = DateTimeHelper.readable_duration(summary_report["total_grand"])
      filtered_list = summary_report["data"].filter { |entry| entry["tags"].include?("work") }
      time_on_work = 0
      report_string = filtered_list.map { |entry|
        time_on_work += entry["dur"]
        "\nProject: #{entry["project"]}, client: #{entry["client"]}\n#{DateTimeHelper.readable_duration(entry["dur"])}\n"
      }
      [
        {
          start: DateTime.parse("#{report_day.year}-#{report_day.month}-#{report_day.day}T05:04:59+02:00"),
          end: DateTime.parse("#{report_day.year}-#{report_day.month}-#{report_day.day}T05:09:59+02:00"),
          title: "Work summary for today",
          duration: 300000,
          calendars_list: ["work"],
          description:
            "Total work time 🕤 logged today:\n➡️#{DateTimeHelper.readable_duration(time_on_work)}\n" \
            "\nTotal time logged last week:\n#{total_time_logged}\n" + report_string.join("\n")
        }
      ]
    end
  end
end
