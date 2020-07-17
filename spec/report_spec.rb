require "spec_helper"

# TODO: everything here needs better names
# TODO: everything here needs to be implemented. For now it's an exercise in public interface design
describe Reports::Daily do
  subject { described_class }
  let(:friday) { Date.parse("2020-05-15") }

  describe "#build_trends" do
    it "should generate a trend data row based on Time Log data for the day" do
    end
  end
end
