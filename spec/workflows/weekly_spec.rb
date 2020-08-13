require "spec_helper"

describe Workflows::Weekly do
  subject { described_class }

  describe "#run" do
    it "should respond to the 'run' message" do
      expect(subject).to respond_to(:run)
    end

    xit "should send a message to the workflow Runner"
  end

  describe "#tasks" do
    it "should respond to the 'tasks' message" do
      expect(subject).to respond_to(:tasks)
    end

    it "should have at least 1 task" do
      expect(subject.tasks).not_to be_empty
    end
  end
end
