require "spec_helper"

describe Workflows::Runner do
  subject { described_class }
  it { should respond_to(:new) }

  describe "#new" do
    xit "should test the interesting stuff"
  end

  describe "instance" do
    subject { described_class.new }
    it { should respond_to(:start) }

    describe "#start" do
      xit "should test the interesting stuff"
    end
  end
end
