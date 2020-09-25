# frozen_string_literal: true

require_relative 'tasks'

module Integrations
  module Todoist
    def self.get_tasks_with(label:)
      Integrations::Todoist::Tasks.filter_by(label: label)
    end
  end
end
