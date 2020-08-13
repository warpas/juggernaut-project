require "spec_helper"

describe Workflows::Runner do
  subject { described_class }

  describe "#new" do
    it { should respond_to(:new) }

    xit "should test the interesting stuff"
  end

  describe "#start" do
    subject { described_class.new }

    it { should respond_to(:start) }

    xit "should test the interesting stuff"
  end
end
