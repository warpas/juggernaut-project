# frozen_string_literal: true

require_relative 'trends'

module Storage
  def self.trends_destination
    Storage::Trends.destination
  end
end
