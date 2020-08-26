require "spec_helper"

describe Activities do
  subject { described_class }

  describe "#list_categories" do
    it { should respond_to(:list_categories) }

    xit "should send a message to the Object responsible"
  end

  describe "#show_log_for" do
    it { should respond_to(:show_log_for) }

    xit "should send a message to the Object responsible"
  end
end
