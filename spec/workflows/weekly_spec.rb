require "spec_helper"

describe Workflows::Weekly do
  subject { described_class }
  it { should respond_to(:run) }
  it { should respond_to(:tasks) }
  it { should_not respond_to(:weekly_scripts) }

  describe "#run" do
    xit "should send a message to the workflow Runner"
  end

  describe "#tasks" do
    it "should have at least 1 task" do
      expect(subject.tasks).not_to be_empty
    end
  end
end
