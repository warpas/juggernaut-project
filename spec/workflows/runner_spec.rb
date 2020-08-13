require "spec_helper"

describe Workflows::Runner do
  subject { described_class }

  describe "#run" do
    it { should respond_to(:new) }
  end
end
