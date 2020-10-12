# frozen_string_literal: true

require_relative '../../requests'
require_relative '../../interface/files/context'

module Integrations
  module Trello
    class Query
      def initialize
        @request_adapter = Requests::Adapter.new
        @config = Integrations::Trello::Config.new
      end

      def run(entity:, id:)
        # TODO: use the id from args eventually
        request_path = build_path(entity: entity, query_id: id)
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
        "https://api.trello.com/1/#{query_structure(entity, query_id)}?#{auth_params}"
      end

      def request_headers
        [{ key: 'Accept', value: 'application/json' }]
      end

      def auth_params
        @config.auth
      end

      def query_structure(entity, entity_id)
        @config.fetch_url_structure(entity: entity, id: entity_id)
      end

      def format_json(response)
        status, body = response.values_at(:status, :body)
        return [] if status != 200

        JSON.parse(body)
      end
    end

    class Config
      def initialize
        @secret = fetch_config
      end

      def auth
        "key=#{api_key}&token=#{api_token}"
      end

      def fetch_url_structure(entity:, id:)
        "#{entity}/#{fetch_entity(entity: entity, id: id)}"
      end

      def fetch_entity(entity: 'boards', id: 'example_board_id')
        @secret['trello'][entity][id]
      end

      private

      def fetch_config
        Interface::Files.fetch_json_from(path: 'lib/integrations/trello/credentials.secret.json')
      end

      def api_key
        @secret['trello']['key']
      end

      def api_token
        @secret['trello']['token']
      end
    end

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
