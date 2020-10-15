# frozen_string_literal: true

module Integrations
  module Trello
    class Card
      attr_reader :name, :id, :url, :description

      def initialize(id:, url:, name:, description:)
        @id = id
        @url = url
        @desc = description
        @description = @name = name
      end
    end
  end
end
