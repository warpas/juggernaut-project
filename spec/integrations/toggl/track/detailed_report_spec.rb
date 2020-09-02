require "spec_helper"

class TogglDouble
  def report_details(date:)
    "TogglDouble.report_details invoked with date: #{date}"
  end
end

# TODO: make sure these test don't send any external requests ‼️‼️
describe Integrations::Toggl::Track::DetailedReport do
  subject { described_class.new(start_date: tuesday, toggl_adapter: TogglDouble.new) }
  let(:tuesday) { Date.parse("2020-09-01") }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:time_entries) }

  describe "#get_entries_for" do
    it "should should return a list of time entries" do
      puts "\nlist = #{subject.time_entries}"
    end
  end
end
