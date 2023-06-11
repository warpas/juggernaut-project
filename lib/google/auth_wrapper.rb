module Google
  class AuthWrapper
    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def self.authorize(credentials_path:, token_path:, scope:)
      begin
        client_id = Google::Auth::ClientId.from_file credentials_path
        token_store = Google::Auth::Stores::FileTokenStore.new file: token_path
        authorizer = Google::Auth::UserAuthorizer.new client_id, scope, token_store
        credentials = authorizer.get_credentials user_id
        if credentials.nil?
          puts "⛔  No credentials error - please authorize  ⛔"
          credentials = re_authorize(authorizer: authorizer)
        end
      rescue Signet::AuthorizationError
        puts "⛔  Authorization failed - requesting re-authorization  ⛔"
        credentials = re_authorize(authorizer: authorizer)
      rescue
        puts "⛔  Unknown error - requesting re-authorization  ⛔"
        credentials = re_authorize(authorizer: authorizer)
      end
      puts "🔑︎  Generated credentials  🔑︎"
      credentials
    end

    private

    def self.re_authorize(authorizer:)
      url = authorizer.get_authorization_url base_url: oob_uri
      puts "Open the following URL in the browser and enter the " \
            "resulting code after authorization:\n" + url
      code = gets
      authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: oob_uri
      )
    end

    def self.oob_uri
      "urn:ietf:wg:oauth:2.0:oob".freeze
    end

    def self.user_id
      "default".freeze
    end
  end
end
