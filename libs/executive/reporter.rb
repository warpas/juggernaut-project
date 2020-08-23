require_relative "../interface/command_line"
require_relative "../toggl/report"
require_relative "../toggl/google_calendar_adapter"
require_relative "../google/calendar"
require_relative "../../date_time_helper"
require "date"

module Executive
  class Reporter
    def self.generate_weekly_work_report
      # TODO: move to Executive::Runner
      log "\n⌨️  Running weekly_work_report script"
      prepared_entry_list = build_weekly_summary(cl_date.to_s)

      calendar = Google::Calendar.new
      calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
    end

    # TODO: move the following functions further
    # TODO: the Workflows context might turn out to be unncessary. Should I merge it wit Executive?
    def self.build_weekly_summary(date_string)
      # TODO: I want this to compare work time with last week
      parsed_date = Date.parse(date_string)
      week_start = DateTimeHelper.get_week_start(parsed_date)
      week_end = DateTimeHelper.get_next_closest_sunday(parsed_date)
      toggl = Toggl::Report.new(week_start, week_end)
      adapter = Toggl::GoogleCalendarAdapter.new
      adapter.build_weekly_summary_from(report: toggl.report_details, report_day: week_end + 1, category: "work")
    end

    def self.last_week_date
      Date.today - 7
    end

    def self.cl_date
      cli = Interface::CommandLine.new(args: ARGV)
      cli.get_runtime_date(default: last_week_date)
    end

    def self.log(string)
      Interface::CommandLine.log_output(string)
    end

    private_class_method :log
    private_class_method :build_weekly_summary
    private_class_method :last_week_date
    private_class_method :cl_date
  end
end
