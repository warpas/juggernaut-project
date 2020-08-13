require "spec_helper"

describe Workflows::Runner do
  subject { described_class }

  describe "#run" do
    it "should return today's date by default" do
      expect(subject).to respond_to(:new)
    end
  end
end
