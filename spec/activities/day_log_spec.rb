require "spec_helper"

class TogglDouble
  def report_details(date:)
    ReportFixture.detailed
  end
end

class TrackerDouble
  def get_entries_for(date:)
    Integrations::Toggl::Track::DetailedReport.new(start_date: date, toggl_connection: TogglDouble.new).time_entries
  end
end

describe Activities::DayLog do
  subject { described_class.new(date: friday, tracker: TrackerDouble.new) }

  let(:friday) { Date.parse("2020-07-17") }

  it { should respond_to(:date) }
  it { should respond_to(:entries) }

  describe "#date" do
    it "should return the date for the log" do
      expect(subject.date).to eq(friday)
    end
  end

  describe "#entries" do
    it "should return a list of activities logged on that day" do
    end
  end

  xdescribe "#split_midnight_entry" do
  end
end
