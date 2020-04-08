module Toggl
  require_relative 'Requests'
  require 'base64'

  class Timer
    def initialize
      puts 'inside Toggl.Timer.initialize'
      @api_token = api_token
      @workspace_id = workspace_id
      @user_agent = user_agent
      @request_adapter = Requests::Adapter.new()
    end

    def print_config
      puts "Toggl API config"
      puts "@api_token = #{@api_token}"
      puts "@workspace_id = #{@workspace_id}"
      puts "@user_agent = #{@user_agent}"
    end

    def authorize
      @request_adapter.get_request(auth_address, auth_headers)
    end

    def get_work_start_time(the_day_in_question)
      the_day_in_question - 4 * 3600
    end

    def get_total_work_time(the_day_in_question)
      2 * 3600
    end

    private

    def api_token
      File.read('.api_token.secret')
    end

    def workspace_id
      File.read('.workspace_id.secret')
    end

    def user_agent
      File.read('.user_agent.secret')
    end

    def basic_auth_token
      # TODO: replace with calculated_token when that's working
      puts "external_token: \n#{external_token}"
      puts "base64_calculated_basic_auth_token: \n#{base64_calculated_basic_auth_token}"
      puts "request_adapter_basic_auth: \n#{request_adapter_basic_auth}"
      external_token
    end

    def external_token
      'Basic ' + File.read('.basic_auth_token.secret')
    end

    def base64_calculated_basic_auth_token
      'Basic ' + Base64.encode64(username + ':' + password).strip
    end

    def request_adapter_basic_auth
      @request_adapter.basic_auth_token(auth_address, username, password)
    end

    def username
      api_token
    end

    def password
      'api_token'
    end

    def auth_address
      'https://www.toggl.com/api/v8/me'
    end

    def auth_headers
      [{key: 'Authorization', value: basic_auth_token}]
    end
  end
end
