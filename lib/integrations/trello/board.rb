# frozen_string_literal: true

require_relative '../../requests'
require_relative '../../interface/files/context'

module Integrations
  module Trello
    class Query
      def initialize
        @request_adapter = Requests::Adapter.new
        @config = fetch_config
      end

      def run(entity:, id:)
        # TODO: use the id from args eventually
        request_path = build_path(entity: entity, query_id: example_id)
        response = @request_adapter.get_request(request_path, request_headers)
        formatted_response = format_json(response)
        { name: formatted_response['name'] }
      end

      private

      attr_reader :config

      def fetch_config
        Interface::Files.fetch_json_from(path: 'lib/integrations/trello/credentials.secret.json')
      end

      def build_path(entity:, query_id:)
        "https://api.trello.com/1/#{entity}/#{query_id}?key=#{api_key}&token=#{api_token}"
      end

      def request_headers
        [{ key: 'Accept', value: 'application/json' }]
      end

      def api_key
        @config['trello']['key']
      end

      def api_token
        @config['trello']['token']
      end

      def example_id
        @config['trello']['example_board_id']
      end

      def format_json(response)
        status, body = response.values_at(:status, :body)
        return [] if status != 200

        JSON.parse(body)
      end
    end

    class Board
      attr_reader :name, :url, :description

      def initialize(id: 'Some_id', trello_query: Integrations::Trello::Query.new)
        board = trello_query.run(entity: 'boards', id: id)
        @description = board[:name]
      end

      def self.get(id: 'Some_id')
        new(id: id)
      end
    end
  end
end
