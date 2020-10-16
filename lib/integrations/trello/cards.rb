# frozen_string_literal: true

require_relative 'card'
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
  end
end
