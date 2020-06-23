module Toggl
  require_relative "../../date_time_helper"
  class GoogleCalendarAdapter
    # TODO: Add unit tests.

    def initialize
      puts "inside Toggl.GoogleCalendarAdapter.initialize"
    end

    def build_entry_list_from(report:)
      puts "\nBuilding the list of events"
      report["data"].map do |entry|
        {
          start: DateTime.parse(entry["start"]),
          end: DateTime.parse(entry["end"]),
          title: entry["description"],
          duration: entry["dur"],
          calendars_list: entry["tags"],
          description: "Duration: #{DateTimeHelper.readable_duration(entry["dur"])}\n" \
          "Client: #{entry["client"]}\nProject: #{entry["project"]}\n" \
          "#{format_total_time_today(report["total_grand"])}\n\n" \
          "Destination calendar: #{entry["tags"]}"
        }
      end
    end

    # TODO: rebuild it to use daily summary, at least partially
    def build_weekly_summary(report:, report_day:)
      total_time_report = format_total_time_last_week(report["total_grand"])
      report_string = report["data"].map { |entry|
        "\nProject: #{entry["title"]["project"]}, client: #{entry["title"]["client"]}\n#{DateTimeHelper.readable_duration(entry["time"])}\n"
      }
      [
        {
          # TODO: calculate end based on start + duration
          start: format_date(report_day, "06:04:59", "+02:00"),
          end: format_date(report_day, "06:09:59", "+02:00"),
          title: "Last week summary",
          duration: 300000,
          calendars_list: ["work"],
          description: total_time_report + report_string.join("\n")
        }
      ]
    end

    def build_weekly_summary_from(report:, report_day:, category:)
      # TODO: Add average work start time
      filtered_list = report["data"].filter { |entry| entry["tags"].include?("work") }
      time_on_work = 0
      report_string = filtered_list.map { |entry|
        time_on_work += entry["dur"]
        "\nProject: #{entry["project"]}, client: #{entry["client"]}\n#{DateTimeHelper.readable_duration(entry["dur"])}\n"
      }
      [
        {
          start: format_date(report_day, "06:04:59", "+02:00"),
          end: format_date(report_day, "06:09:59", "+02:00"),
          title: "Last week summary",
          duration: 300000,
          calendars_list: ["work"],
          description:
          "#{format_work_time_last_week(time_on_work)}" \
          "\n#{format_total_time_last_week(report["total_grand"])}" \
          "\n#{separator}\n#{report_string.join("\n")}"
        }
      ]
    end

    def build_daily_summary_from(report:, report_day:, category:)
      # TODO: Add work start time
      puts "\nBuilding the daily summary event"
      total_time_logged = DateTimeHelper.readable_duration(report["total_grand"])
      filtered_list = report["data"].filter { |entry| entry["tags"].include?("work") }
      time_on_work = 0
      report_string = filtered_list.map { |entry|
        time_on_work += entry["dur"]
        "\nProject: #{entry["project"]}, client: #{entry["client"]}\n#{DateTimeHelper.readable_duration(entry["dur"])}\n"
      }
      [
        {
          start: format_date(report_day, "05:04:59", "+02:00"),
          end: format_date(report_day, "05:09:59", "+02:00"),
          title: "Daily work summary",
          duration: 300000,
          calendars_list: [category],
          description:
            "#{format_time_today_for(time: time_on_work, category: category)}" \
            "\n#{format_time_today_for(time: report["total_grand"], category: "total")}" \
            "\n#{separator}\n#{report_string.join("\n")}"
        }
      ]
    end

    def build_daily_creative_summary_from(report:, report_day:, category:)
      # TODO: Add work start time
      puts "\nBuilding the daily summary event"
      total_time_logged = DateTimeHelper.readable_duration(report["total_grand"])
      filtered_list = report["data"].filter { |entry| entry["tags"].include?(category) }
      time_on_category = 0
      report_string = filtered_list.map { |entry|
        time_on_category += entry["dur"]
        "\nProject: #{entry["project"]}, client: #{entry["client"]}\n#{DateTimeHelper.readable_duration(entry["dur"])}\n"
      }
      [
        {
          # TODO: figure out what to do about start and end time
          start: format_date(report_day, "05:34:59", "+02:00"),
          end: format_date(report_day, "05:39:59", "+02:00"),
          title: "Daily #{category} summary",
          duration: 300000,
          calendars_list: [category],
          description:
            "#{format_time_today_for(time: time_on_category, category: category)}" \
            "\n#{format_time_today_for(time: report["total_grand"], category: "total")}" \
            "\n#{separator}\n#{report_string.join("\n")}"
        }
      ]
    end

    private

    def format_date(date, time, timezone)
      DateTime.parse("#{date.year}-#{date.month}-#{date.day}T#{time}#{timezone}")
    end

    def format_total_time_today(time_in_milliseconds)
      readable_time = DateTimeHelper.readable_duration(time_in_milliseconds)
      "⏱Total time logged today:\n#{readable_time}\n"
    end

    def format_time_today_for(time:, category:)
      readable_time = DateTimeHelper.readable_duration(time)
      "#{format_by(category)} time logged today:\n➡️#{readable_time}\n"
    end

    def format_by(option)
      if option == "game"
        return "🎮Game"
      elsif option == "work"
        return "🕤Work"
      elsif option == "total"
        return "⏱Total"
      else
        return "❓Unknown"
      end
    end

    def format_total_time_last_week(time_in_milliseconds)
      readable_time = DateTimeHelper.readable_duration(time_in_milliseconds)
      "⏱Total time logged last week:\n#{readable_time}\n"
    end

    def format_work_time_last_week(time_in_milliseconds)
      readable_time = DateTimeHelper.readable_duration(time_in_milliseconds)
      "🕤Work time logged last week:\n➡️#{readable_time}\n"
    end

    def separator
      "-----------------------------"
    end
  end
end
