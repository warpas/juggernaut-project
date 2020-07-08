module Requests
  require "faraday"

  class Adapter
    def initialize
      puts "inside RequestAdapter.initialize"
    end

    def get_request(address, headers)
      # TODO: Add unit tests.
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
        puts "Error: #{response.reason_phrase}, #{response.body}"
        "Something went wrong in GET request to #{address}"
      end
    end

    def post_request(address, headers, body)
      puts "sending a POST request to #{address}"

      # TODO: replace it with Faraday.new?
      response = Faraday.post(address) { |request|
        headers.each do |header|
          request.headers[:content_type] = 'application/json'
          request.headers[header[:key]] = header[:value]
          request.body = body
        end
      }
      puts "\nResponse:"
      if response.status == 200
        response.to_hash
      else
        puts "Error: #{response.reason_phrase}, #{response.body}"
        "Something went wrong in POST request to #{address}"
      end
    end

    def delete_request(address, headers)
      puts "sending a DELETE request to #{address}"

      # TODO: replace it with Faraday.new?
      response = Faraday.delete(address) { |request|
        headers.each do |header|
          request.headers[header[:key]] = header[:value]
        end
      }
      if response.status == 200
        response.to_hash
      else
        puts "Error: #{response.reason_phrase}, #{response.body}"
        "Something went wrong in DELETE request to #{address}"
      end
    end

    def basic_auth_token(auth_address, username, password)
      Faraday.new(url: auth_address).basic_auth(username, password)
    end
  end
end
