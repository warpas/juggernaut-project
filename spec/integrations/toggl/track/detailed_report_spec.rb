require "spec_helper"

class TogglDouble
  def report_details(date:)
    ReportFixture.detailed
  end
end

# TODO: make sure these test don't send any external requests ‼️‼️
describe Integrations::Toggl::Track::DetailedReport do
  subject {
    described_class.new(
      start_date: friday,
      toggl_connection: TogglDouble.new
    )
  }
  let(:friday) { Date.parse("2020-07-17") }
  let(:reported_seconds) { 66293 }
  let(:time_entries_count) { 13 }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:recorded_seconds) }
  it { should respond_to(:entries_count) }
  it { should respond_to(:time_entries) }

  describe "#recorded_seconds" do
    it "should should return the total time logged (in seconds)" do
      expect(subject.recorded_seconds).to eq(reported_seconds)
    end
  end

  describe "#entries_count" do
    it "should should return the total time entries count from the report" do
      expect(subject.entries_count).to eq(time_entries_count)
    end
  end

  describe "#time_entries" do
    it "should should return a list of time entries" do
      expect(subject.time_entries.length).to eq(time_entries_count)
    end

    context "single entry" do
      let(:time_entry) { subject.time_entries.first }

      it "should respond to clients" do
        expect(subject.time_entries.first).to respond_to(:client)
        expect(subject.time_entries.first).to respond_to(:description)
        expect(subject.time_entries.first).to respond_to(:project)
        expect(subject.time_entries.first).to respond_to(:start_time)
        expect(subject.time_entries.first).to respond_to(:end_time)
      end
    end
  end
end
