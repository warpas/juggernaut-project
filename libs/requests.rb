module Requests
  require "faraday"
  class Adapter
    def initialize
      puts "inside RequestAdapter.initialize"
    end

    def get_request(address, headers)
      # TODO: Add unit tests.

      puts "inside RequestAdapter.get_request"
      puts "sending a GET request to #{address}"

      # TODO: replace it with Faraday.new?
      response = Faraday.get(address) { |request|
        headers.each do |header|
          request.headers[header[:key]] = header[:value]
        end
      }
      if response.status == 200
        response.to_hash
      else
        "Something went wrong in GET request to #{address}"
      end
    end

    def post_request(address, headers, body)
      # TODO: Add handling.
    end

    def basic_auth_token(auth_address, username, password)
      Faraday.new(url: auth_address).basic_auth(username, password)
    end
  end
end
