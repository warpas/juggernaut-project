require "spec_helper"

describe Executive do
  subject { described_class }
  it { should respond_to(:generate_weekly_work_report) }
  it { should respond_to(:send_activities_to_calendar) }

  describe "#generate_weekly_work_report" do
    xit "should send a message to the Object responsible"
  end

  describe "#send_activities_to_calendar" do
    xit "should send a message to the Object responsible"
  end
end
