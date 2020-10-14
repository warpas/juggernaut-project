# frozen_string_literal: true

require_relative 'query'

module Integrations
  module Trello
    class Cards
      attr_reader :list

      def initialize(list_id:, trello_query: Integrations::Trello::Query.new)
        @query_runner = trello_query
        cards_list = query_runner.run_cards_query(entity: 'lists', id: list_id)
        @list = cards_list.map do |card|
          Integrations::Trello::Card.new(card)
        end
      end

      private

      attr_reader :query_runner
    end

    class Card
      attr_reader :name, :id, :url, :description

      def initialize(id:, url:, name:, description:)
        @id = id
        @url = url
        @desc = description
        @description = @name = name
      end
    end

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
        Integrations::Trello::Board.new(id: id)
      end

      def fetch_cards(list: 'List')
        lists = fetch_lists
        cards = []
        lists.each do |trello_list|
          next unless trello_list[:name] == list

          cards = Integrations::Trello::Cards.new(list_id: trello_list[:id])
        end
        cards.list
      end

      def fetch_lists
        query_runner.run_lists_query(entity: 'boards', id: id)
      end

      private

      attr_reader :query_runner
    end
  end
end
