module Toggl
  require_relative 'Requests'
  require 'base64'
  require 'json'

  class Timer
    def initialize(only_date)
      puts 'inside Toggl.Timer.initialize'
      @api_token = api_token
      @workspace_id = workspace_id
      @user_agent = user_agent
      @start_date = only_date
      @end_date = only_date
      @request_adapter = Requests::Adapter.new()
    end

    def print_config
      puts "Toggl API config"
      puts "@api_token = #{@api_token}"
      puts "@workspace_id = #{@workspace_id}"
      puts "@user_agent = #{@user_agent}"
    end

    def authorize
      response = @request_adapter.get_request(auth_address, auth_headers)
      body = JSON.parse(response[:body])
      @user_agent = body["data"]["email"]
    end

    def report_summary
      response = @request_adapter.get_request(report_summary_address, auth_headers)
      body = JSON.parse(response[:body])
      response
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
      # puts "external_token: \n#{external_token}"
      # puts "base64_calculated_basic_auth_token: \n#{base64_calculated_basic_auth_token}"
      # puts "request_adapter_basic_auth: \n#{request_adapter_basic_auth}"
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

    def report_summary_address
      "https://toggl.com/reports/api/v2/summary?user_agent=#{@user_agent}&workspace_id=#{@workspace_id}&since=#{@start_date}&until=#{@end_date}&grouping=clients&subgrouping=projects&rounding=on"
    end

    def auth_headers
      [{key: 'Authorization', value: basic_auth_token}]
    end
  end
end
