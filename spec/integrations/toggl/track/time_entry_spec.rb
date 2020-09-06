require "spec_helper"

describe Integrations::Toggl::Track::TimeEntry do
  subject { described_class.new(client: "Client 1") }
  let(:friday) { Date.parse("2020-07-17") }
  let(:friday_noon) { Time.parse(friday.to_s) + 12 * 3600 }
  let(:two_hours) { 2 * 3600 }
  it { should respond_to(:client) }
  it { should respond_to(:project) }
  it { should respond_to(:description) }
  it { should respond_to(:tags) }
  it { should respond_to(:duration) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }

  describe "#new" do
    it "should return the object with all parameters" do
      expect(described_class.new(
        client: "Client 1",
        project: "Abnegation - Games",
        description: "Black Mesa",
        tags: ["game"],
        duration: two_hours,
        start_time: friday_noon,
        end_time: friday_noon + two_hours
      ).start_time).to eq(friday_noon)
    end
  end
end
