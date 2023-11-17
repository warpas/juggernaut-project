# frozen_string_literal: true

require 'spec_helper'

describe Google::Calendar do
  let(:subject) { described_class.new(calendar_name: "test") }
  let(:tomorrows_events) { subject.fetch_events(Date.new(2023,7,12)) }
  it { should respond_to(:fetch_events) }

  describe '#fetch_events' do
    it 'should return an Array of Event objects' do
      expect(tomorrows_events.all? {|item| item.class == Google::Apis::CalendarV3::Event}).to eq(true)
    end
  end
end
