# frozen_string_literal: true

require 'spec_helper'

describe Integrations::Todoist::Tasks do
  subject do
    described_class.new
  end
  it { should respond_to(:list) }
end
