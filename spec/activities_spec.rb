require "spec_helper"

# TODO: everything here needs better names
# TODO: everything here needs to be implemented. For now it's an exercise in public interface design
describe Activities::Log do
  subject { described_class }
  let(:friday) { Date.parse("2020-07-17") }

  describe "#list_for" do
    it "should return a list of activities logged on the specified day" do
    end
  end
end
