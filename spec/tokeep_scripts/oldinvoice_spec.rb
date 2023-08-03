# frozen_string_literal: true

require 'spec_helper'

describe OldInvoice do
  subject { OldInvoice.new(config: DefaultConfig.new, input_date: Date.new(2023,7,11)) }
  let(:test_calendar) { Google::Calendar.new(calendar_name: 'test') }
  let(:test_date_with_events) { Date.new(2023,7,12).to_s }
  let(:test_events) { subject.get_events_from(date: test_date_with_events, source_calendar: test_calendar) }
  let(:test_date_without_events) { Date.new(2023,7,11).to_s }
  let(:test_no_events) { subject.get_events_from(date: test_date_without_events, source_calendar: test_calendar) }
  let(:test_mock_events) { SheetOutput.open_struct_list }
  let(:test_mock_events_with_ns) { SheetOutput.open_struct_list_with_ns }
  let(:test_single_row_output) { SheetOutput.test_value_of_a_single_row }
  let(:test_single_row_output_with_ns) { SheetOutput.test_value_of_a_single_row_with_ns }
  let(:test_list_of_rows) {SheetOutput.test_value_of_rows_list}
  let(:test_mock_event_list_with_ns) {SheetOutput.mock_event_list_with_ns}
  it { should respond_to(:run_test_script) }

  describe '#run_test_script' do
    it 'returns a row list in the correct format' do
      expect(subject.run_test_script).to eq(test_list_of_rows)
    end
  end

  describe '#run_mock_test_script' do
    it 'returns a row list in the correct format' do
      expect(subject.run_mock_test_script).to eq(test_list_of_rows)
    end
  end

  # TODO: Test empty day returns empty array
  describe '#build_minimal_row' do
    it 'returns a row in the correct format' do
      expect(subject.build_minimal_row(date: test_date_with_events, events: test_events)).to eq(test_single_row_output)
    end

    it 'returns an empty array if there are no events' do
      expect(subject.build_minimal_row(date: test_date_without_events, events: test_no_events)).to eq([])
    end

    it 'returns a row in the correct format when passed mock events' do
      expect(subject.build_minimal_row(date: test_date_with_events, events: test_mock_events)).to eq(test_single_row_output)
    end

    it 'returns a row in the correct format when passed mock events' do
      expect(subject.build_minimal_row(date: test_date_with_events, events: test_mock_events_with_ns)).to eq(test_single_row_output_with_ns)
    end

    it 'returns a row in the correct format when passed mock events' do
      expect(subject.build_minimal_row(date: test_date_with_events, events: test_mock_event_list_with_ns)).to eq(test_single_row_output_with_ns)
    end
  end

  describe '#get_events_from' do
    it 'returns the correct amount of events for the day' do
      expect(subject.get_events_from(date: test_date_with_events, source_calendar: test_calendar).length).to eq(2)
    end

    it 'returns no events for a day with no events' do
      expect(subject.get_events_from(date: test_date_without_events, source_calendar: test_calendar).length).to eq(0)
    end

    it 'returns an array of objects, that respond to the color_id method' do
      expect(subject.get_events_from(date: test_date_with_events, source_calendar: test_calendar).first).to respond_to(:color_id)
    end

    it 'returns an array of objects, that respond to the summary method' do
      expect(subject.get_events_from(date: test_date_with_events, source_calendar: test_calendar).first).to respond_to(:summary)
    end

    it 'returns an array of CalendarAdapter::Event objects' do
      expect(subject.get_events_from(date: test_date_with_events, source_calendar: test_calendar).all? { |event| event.class == CalendarAdapter::Event }).to eq(true)
    end
  end

  describe '#test_mock_events' do
    it 'has two elements' do
      expect(test_mock_events.length).to eq(2)
    end
  end
end
