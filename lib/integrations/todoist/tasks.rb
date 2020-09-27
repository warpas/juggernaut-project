# frozen_string_literal: true

require_relative 'query'

module Integrations
  module Todoist
    class Tasks
      attr_reader :list

      def initialize(label: 'Label', todoist_query: Integrations::Todoist::Query.new)
        @list = todoist_query.run(entity: 'tasks', label: label)
      end

      def self.filter_by(label:)
        new(label: label).list
      end
    end
  end
end
