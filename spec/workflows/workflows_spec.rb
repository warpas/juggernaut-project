require "spec_helper"

describe Workflows do
  subject { described_class }
  it { should respond_to(:run_weekly_workflow) }
  it { should respond_to(:run_daily_workflow) }

  describe "#run_weekly_workflow" do
    xit "should send a message to the Weekly workflow"
  end

  describe "#run_daily_workflow" do
    xit "should send a message to the Daily workflow"
  end
end
