# frozen_string_literal: true

require 'spec_helper'

# TODO: make sure these test don't send any external requests
describe Integrations::Todoist do
  subject { described_class }
  it { should respond_to(:get_tasks_with) }

  describe '#get_tasks_with' do
    xit 'should send a message to the Object responsible'
  end
end
