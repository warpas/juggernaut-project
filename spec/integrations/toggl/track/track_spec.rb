require "spec_helper"

# TODO: make sure these test don't send any external requests
describe Integrations::Toggl::Track do
  subject { described_class }
  it { should respond_to(:get_entries_for) }

  describe "#get_entries_for" do
    xit "should send a message to the Object responsible"
  end
end
