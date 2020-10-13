# frozen_string_literal: true

require_relative '../../interface/files/context'

module Integrations
  module Trello
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
  end
end
