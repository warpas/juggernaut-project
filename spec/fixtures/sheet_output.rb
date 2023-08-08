require 'ostruct'

module SheetOutput
  def self.test_value_of_rows_list
    [["2023-07-12", 2, 0, 0], ["2023-07-13", 2, 0, 0]]
  end

  def self.test_value_of_rows_list_with_ns
    [["2023-07-12", 2, 0, 1], ["2023-07-13", 2, 0, 1]]
  end

  def self.test_value_of_a_single_row
    ["2023-07-12", 2, 0, 0]
  end

  def self.test_value_of_a_single_row_with_ns
    ["2023-07-12", 2, 0, 1]
  end

  def self.open_struct_list
    [
      OpenStruct.new(
        {
          summary: ""
        }
      ),
      OpenStruct.new(
        {
          summary: ""
        }
      )
    ]
  end

  def self.open_struct_list_with_ns
    [
      OpenStruct.new(
        {
          summary: "(NS)"
        }
      ),
      OpenStruct.new(
        {
          summary: ""
        }
      )
    ]

  end

  def self.mock_event_list_with_ns
    [
      MockEvent.new(
        summary: "(NS)",
        color_id: 6
      ),
      MockEvent.new(
        summary: "",
        color_id: 6
      )
    ]

  end
end

class MockEvent < CalendarEvent
end
