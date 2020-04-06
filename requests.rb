module Requests
  require 'faraday'
  class Adapter
    def initialize
      puts 'inside RequestAdapter.initialize'
    end

    def get_request(address, headers)
      puts 'inside RequestAdapter.get_request'
      puts "sending a GET request to #{address}"

      # TODO: replace it with Faraday.new?
      response = Faraday.get(address) do |request|
        headers.each do |header|
          request.headers[header[:key]] = header[:value]
        end
      end
      puts "response.status = #{response.status}"
      response
    end

    def basic_auth_token(auth_address, username, password)
      Faraday.new(url: auth_address).basic_auth(username, password)
    end
  end
end
