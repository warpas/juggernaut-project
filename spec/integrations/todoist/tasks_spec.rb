# frozen_string_literal: true

require 'spec_helper'

describe Integrations::Todoist::Tasks do
  subject do
    described_class.new
  end
  it { should respond_to(:list) }
  # it { should respond_to(:filter) }

  # TODO: make sure these test don't send any external requests
  # describe '#with' do
  #   it 'should should return the total time logged (in seconds)' do
  #     expect(subject.recorded_seconds).to eq(reported_seconds)
  #   end
  # end
end
