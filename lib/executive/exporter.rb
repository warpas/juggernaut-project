# frozen_string_literal: true

require_relative '../command_line'
require_relative '../interface/command_line'
require_relative '../analysis/context'
require_relative '../storage/context'
require_relative '../toggl/report'
require_relative '../toggl/google_calendar_adapter'
require_relative '../google/calendar'
require_relative '../google/sheets'
require 'date'

# TODO: Add unit tests.

module Executive
  class Exporter
    # Activities to calendar export functions below

    def self.need_a_good_name_for_this_but_now_its_publish_entries
      log "\n⌨️  Running send_toggl_to_calendar script"
      # def compare_goals_to_reality

      # TODO: change the way date is given. Ideally a GUI with a date picker.
      date = CommandLineOldest.get_date_from_command_line(ARGV)

      prepared_entry_list =
        if date.empty?
          build_calendar_entry_from(days_ago: 1)
        else
          get_entry_list_for(Date.parse(date))
        end

      calendar = Google::Calendar.new
      # TODO: Add or update, instead of just add.
      calendar.add_list_of_entries_no_duplicates(prepared_entry_list)
    end

    def self.build_calendar_entry_from(days_ago:)
      # TODO: move what should be in Toggl API to toggl file.
      date = Date.today - days_ago
      get_entry_list_for(date)
    end

    def self.get_entry_list_for(date)
      toggl = Toggl::Report.new(date)
      adapter = Toggl::GoogleCalendarAdapter.new
      adapter.build_entry_list_from(report: toggl.report_details)
    end

    # Trends export functions below

    def self.daily_trends_datapoints
      log "\n⌨️  Running daily_trends_data_export script"
      do_the_trend_work_once unless trends_already_exported
    end

    def self.trends_already_exported
      false
    end

    def self.do_the_trend_work_once
      # TODO: Modify this to ignore reported dates
      # TODO: Split into 2 scripts
      do_everything_once(date: get_report_date)
    end

    # TODO: unused, separate into another script
    def self.do_the_trend_work_for(days: 1)
      (1..days).reverse_each do |day|
        do_everything_once(date: (Date.today - day))
      end
    end

    def self.get_report_date
      cli = Interface::CommandLineWithoutContext.new(args: ARGV)
      cli.get_runtime_date(default: Date.today) - 1
    end

    def self.do_everything_once(date: (Date.today - 1))
      values = Analysis.build_daily_trends_report(date: date)

      # TODO: only append if the date is not already there
      # TODO: maybe update if the date is there but the values are different?
      send(payload: values, destination: trends_destination_legacy)
      log "📈  Trend data appended for #{date}"
    end

    def self.send(payload:, destination:)
      destination.append_trend_datapoint(payload: payload)
    end

    def self.trends_destination_legacy
      Google::Sheets.new(file_id: 'trends')
    end

    def self.trends_destination
      Storage.trends_destination
    end

    # Private utils functions below

    def self.log(string)
      Maintenance::Logger.log_info(message: string)
    end

    private_class_method :log
  end
end
