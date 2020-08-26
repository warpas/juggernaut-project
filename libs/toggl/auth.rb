module Toggl
  require "base64"
  require "json"

  class Auth
    def self.headers
      [{key: "Authorization", value: basic_auth_token}]
    end

    private

    def self.get_json_from_file(file_path)
      file = File.read(file_path)
      JSON.parse(file)
    end

    def self.basic_auth_token
      "Basic " + Base64.encode64(api_token + ":api_token").strip
    end

    def self.api_token
      config = get_json_from_file("lib/toggl/config.secret.json")
      config["tokens"]["api"]
    end
  end
end
