# frozen_string_literal: true

require 'json'

module Interface
  module Files
    def self.fetch_json_from(path:)
      file = File.read(path)
      JSON.parse(file)
    end
  end
end
