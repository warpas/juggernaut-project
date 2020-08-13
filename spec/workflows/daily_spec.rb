require "spec_helper"

describe Workflows::Daily do
  subject { described_class }

  describe "#run" do
    it { should respond_to(:run) }

    xit "should send a message to the workflow Runner"
  end

  describe "#tasks" do
    it { should respond_to(:tasks) }

    it "should have at least 1 task" do
      expect(subject.tasks).not_to be_empty
    end
  end
end
