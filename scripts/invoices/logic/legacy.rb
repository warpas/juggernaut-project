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
    events = source_calendar.fetch_events(date)

    daily_ns_count = 0
    categories = @config.event_categories
    event_categories_list = events.map do |event|
      daily_ns_count += 1 if event.summary.include?('(NS)')
      selection = categories.select { |category| category[:color] == event.color_id }

      selection.empty? ? @config.default_category_name : selection.first[:name]
    end
    puts event_categories_list
    puts "daily_ns_count = #{daily_ns_count}"

    result_array = [date]
    categories.each do |category|
      result_array << event_categories_list.count(category[:name])
    end
    result_array << daily_ns_count

    _head, *tail = *result_array
    return [] if tail.sum.zero?

    p result_array
  end

  def build_list(month_number:, year_number:, calendar:)
    # TODO: smarter cycle through days of month
    days = (1..31)
    row_list = []
    skipped_dates = []
    days.each do |day|
      # TODO: connect date and sheet name for this case

      date = "#{year_number}-#{month_number}-#{day}"
      split_date = date.split('-')
      is_date_valid = Date.valid_date?(split_date[0].to_i, split_date[1].to_i, split_date[2].to_i)
      puts "is #{date} valid? #{is_date_valid}"
      next unless is_date_valid

      row_candidate = build_row(date:, source_calendar: calendar)
      if !row_candidate.empty?
        row_list << row_candidate
      else
        # TODO: is this useful? Make it useful or get rid of it
        skipped_dates << [date]
      end
    end
    row_list
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

    p row_list
    add_timestamp(destination_sheet: sheet_name)
    send_list_to_sheets(destination_sheet: sheet_name, row_list: row_list)
    puts "✅ sheet_name = #{sheet_name}"
  end

  ## NEW CODE ##

  def run_test_script
    file_code = @config.file_code

    calendar = @config.calendar

    month_number = @input_date.strftime('%m')
    year_number = @input_date.strftime('%Y')
    sheet_name = "#{@input_date.strftime('%B')}_#{year_number}"

    row_list = build_list(month_number: month_number, year_number: year_number, calendar: calendar)

    row_list
  end

  def run_mock_test_script
    file_code = @config.file_code

    calendar = @config.calendar

    month_number = @input_date.strftime('%m')
    year_number = @input_date.strftime('%Y')
    sheet_name = "#{@input_date.strftime('%B')}_#{year_number}"

    row_list = build_minimal_list(month_number: month_number, year_number: year_number, calendar: calendar)

    row_list
  end

  def build_minimal_row(date:, events:)
    # TODO: wypieprzyc pierwsza linijke (ze wzgledu na source_calendar) chodzi o pozbycie sie tego argumentu (dependency injection i rzeczy)
    # zamiast tego argumentu bedzie to dostawac argument w postaci listy eventów :events
    # jaki to ma mieć kształt? Nie pełne odtworzenie, ale część wartości


    # p " lista eventów #{events.length}, #{events}"
    daily_ns_count = 0
    categories = @config.event_categories
    event_categories_list = events.map do |event|
      daily_ns_count += 1 if event.summary.include?('(NS)')
      selection = categories.select { |category| category[:color] == event.color_id }

      selection.empty? ? @config.default_category_name : selection.first[:name]
    end

    result_array = [date]
    categories.each do |category|
      result_array << event_categories_list.count(category[:name])
    end
    result_array << daily_ns_count

    _head, *tail = *result_array
    return [] if tail.sum.zero?

    result_array
  end

  def get_events_from(date:, source_calendar:)
    # TODO: tutaj trzeba dodać objekt który będzie parowany z mockiem na następnym etapie
    events = source_calendar.fetch_events(date)
    events.map { |event| CalendarAdapter::Event.new(summary: event.summary, color_id: event.color_id) }
  end

  def run_minimal_test_script
   build_list(month_number: month_number, year_number: year_number, calendar: calendar)
  end

  def build_minimal_list
    build_list(calendar_content:)
  end
end
