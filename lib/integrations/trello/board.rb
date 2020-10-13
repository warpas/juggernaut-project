# frozen_string_literal: true

require_relative 'query'

module Integrations
  module Trello
    class Board
      attr_reader :name, :url, :description

      def initialize(id: 'example_board_id', trello_query: Integrations::Trello::Query.new)
        board = trello_query.run(entity: 'boards', id: id)
        @description = board[:name]
      end

      def self.get(id: 'example_board_id')
        new(id: id)
      end
    end
  end
end
