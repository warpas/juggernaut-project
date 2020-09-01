require "spec_helper"

# TODO: make sure these test don't send any external requests
describe Integrations::Toggle::Track::DetailedReport do
  subject { described_class.new(start_date: tuesday) }
  let(:tuesday) { Date.parse("2020-09-01") }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }

  describe "#get_entries_for" do
    xit "should send a message to the Object responsible"
  end
end
