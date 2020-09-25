# frozen_string_literal: true

require 'spec_helper'

describe Tasks do
  subject { described_class }
  it { should respond_to(:list_important) }

  describe '#list_important' do
    xit 'should send a message to the Object responsible'
  end
end
