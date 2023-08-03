# frozen_string_literal: true

class DefaultConfig
  def initialize; end

  def calendar
    @calendar ||= Google::Calendar.new(
      calendar_name: 'test'
    )
  end

  def sheet_file
    @sheet_file ||= Google::Sheets.new(
      file_id: 'test'
    )
  end

  def file_code
    'test'
  end

  def timestamp_cell
    'C1'
  end

  def report_range
    'B3:M35'
  end

  def default_category_name
    'test'
  end

  def event_categories
    [
      {
        color: '21',
        name: 'test'
      },
      {
        color: '20',
        name: 'test_2'
      }
    ]
  end
end
