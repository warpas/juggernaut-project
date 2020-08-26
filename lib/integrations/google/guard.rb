require_relative "../interface/command_line"
require_relative "../maintenance/context"
require "googleauth"
require "googleauth/stores/file_token_store"

module Integrations
  module Google
    class Guard
      def initialize(credentials_path:, token_path:, scope:)
        client_id = Google::Auth::ClientId.from_file credentials_path
        token_store = Google::Auth::Stores::FileTokenStore.new file: token_path
        authorizer = Google::Auth::UserAuthorizer.new client_id, scope, token_store
        authorize(authorizer: authorizer)
      end
      ##
      # Ensure valid credentials, either by restoring from the saved credentials
      # files or intitiating an OAuth2 authorization. If authorization is required,
      # the user's default browser will be launched to approve the request.
      #
      # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
      def authorize(authorizer:)
        credentials = authorizer.get_credentials user_id
        if credentials.nil?
          url = authorizer.get_authorization_url base_url: oob_uri
          log "Open the following URL in the browser and enter the " \
              "resulting code after authorization:\n" + url
          code = get_input
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: oob_uri
          )
        end
        credentials
      end

      private

      def oob_uri
        "urn:ietf:wg:oauth:2.0:oob".freeze
      end

      def user_id
        "default".freeze
      end

      def log(string)
        Maintenance::Logger.log_info(message: string)
      end

      def get_input
        Interface::CommandLine.new.get_input
      end
    end
  end
end
