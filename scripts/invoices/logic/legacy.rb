# frozen_string_literal: true

require_relative '../../../lib/google/calendar'
require_relative '../../../lib/google/sheets'
require_relative '../config/default'
require 'json'

class OldInvoice
  def initialize(config: DefaultConfig.new, input_date: Date.today)
    # input_date = Date.today.prev_month # Date override
    # TODO: do the override above in a better way

    @config = config
    @input_date = input_date
  end

  def build_row(date:, source_calendar:)
    []
  end

  def build_list(month_number:, year_number:, calendar:)
    []
  end

  def send_list_to_sheets(destination_sheet:, row_list:)
    @config.sheet_file.send_to_sheets(values: row_list, range: "#{destination_sheet}!#{@config.report_range}")
  end

  def add_timestamp(destination_sheet:)
    timestamp = [[Time.now.strftime('%Y-%m-%d %H:%M:%S')]]
    @config.sheet_file.send_to_sheets(values: timestamp, range: "#{destination_sheet}!#{@config.timestamp_cell}")
  end

  def run_script
    file_code = @config.file_code

    puts "\n⌨️  Running #{file_code} script for #{@input_date}\n\n"
    calendar = @config.calendar

    month_number = @input_date.strftime('%m')
    year_number = @input_date.strftime('%Y')
    sheet_name = "#{@input_date.strftime('%B')}_#{year_number}"

    row_list = build_list(month_number: month_number, year_number: year_number, calendar: calendar)
    puts "row_list = #{row_list}"
    puts "Sending to #{file_code} file. Sheet name #{sheet_name}"

    add_timestamp(destination_sheet: sheet_name)
    send_list_to_sheets(destination_sheet: sheet_name, row_list: row_list)
    puts "✅ sheet_name = #{sheet_name}"
  end
end
