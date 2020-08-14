require "spec_helper"

describe Executive::Reporter do
  subject { described_class }
  it { should respond_to(:generate_weekly_work_report) }

  describe "#generate_weekly_work_report" do
    xit "should send a message to the workflow Runner"
  end
end
