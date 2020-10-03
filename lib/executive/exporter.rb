# frozen_string_literal: true

require_relative '../command_line'
require_relative '../interface/command_line'
require_relative '../analysis/context'
require_relative '../toggl/report'
require_relative '../toggl/google_calendar_adapter'
require_relative '../google/calendar'
require_relative '../google/sheets'
require 'date'

# TODO: Add unit tests.

module Executive
  class Exporter
    def self.need_a_good_name_for_this_but_now_its_publish_entries
      # def compare_goals_to_reality

      puts "\n⌨️  Running send_toggl_to_calendar script"
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

    def self.daily_trends_datapoints
      do_the_trend_work unless trends_already_exported
    end

    def self.trends_already_exported
      false
    end

    def self.do_the_trend_work
      puts "\n⌨️  Running daily_trends_data_export script"

      cli = Interface::CommandLineWithoutContext.new(args: ARGV)
      report_date = cli.get_runtime_date(default: Date.today) - 1

      # TODO: Modify this to ignore reported dates
      # TODO: Split into 2 scripts
      # loop_for(days: 60)
      do_everything_once(date: report_date)
    end

    def self.loop_for(days: 1)
      (1..days).reverse_each do |day|
        do_everything_once(date: (Date.today - day))
      end
    end

    def self.do_everything_once(date: (Date.today - 1))
      values = Analysis.build_daily_trends_report(date: date)

      # TODO: only append if the date is not already there
      # TODO: maybe update if the date is there but the values are different?
      Google::Sheets
        .new(file_id: 'trends')
        .append_to_sheet(values: values, range: 'Data!A:I')
      # trends_sheet.get_spreadsheet_values(range: "Data!A:I")
      puts "📈  Trend data appended for #{date}"
    end
  end
end
