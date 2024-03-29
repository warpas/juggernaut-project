# frozen_string_literal: true

require_relative 'query'
require_relative 'cards'

module Integrations
  module Trello
    class Board
      attr_reader :name, :id, :url, :description, :lists

      def initialize(id: 'example_board_id', trello_query: Integrations::Trello::Query.new)
        @query_runner = trello_query
        board = query_runner.run(entity: 'boards', id: id)
        @id = id
        @trello_id = board[:id]
        @url = board[:url]
        @name = board[:name]
        @description = "Board: #{@name}"
      end

      def self.get(id: 'example_board_id')
        puts "Board ID: #{id}"
        Integrations::Trello::Board.new(id: id)
      end

      def fetch_cards(list_name: 'List')
        lists = fetch_lists
        cards = []
        lists.each do |trello_list|
          next unless trello_list[:name].include?(list_name)

          cards = Integrations::Trello::Cards.new(list_id: trello_list[:id])
        end
        cards.list
      end

      def fetch_lists
        query_runner.run_lists_query(entity: 'boards', id: id)
      end

      def add_card_to_list(list_name: 'Dependencies (waiting)')
        query_runner.run_create_cards_command(list_id: list_name)
      end

      private

      attr_reader :query_runner
    end
  end
end
