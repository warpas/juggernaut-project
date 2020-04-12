module Toggl
  require_relative 'Requests'
  require 'base64'
  require 'json'

  class Timer
    def initialize(only_date)
      puts 'inside Toggl.Timer.initialize'
      @api_token = api_token
      @workspace_id = workspace_id
      @start_date = only_date
      @end_date = only_date
      @request_adapter = Requests::Adapter.new
      @user_agent = get_user_email
    end

    def print_config
      puts "Toggl API config"
      puts "@api_token = #{@api_token}"
      puts "@workspace_id = #{@workspace_id}"
      puts "@user_agent = #{@user_agent}"
    end

    def get_user_email
      response = @request_adapter.get_request(auth_address, auth_headers)
      body = JSON.parse(response[:body])
      body["data"]["email"]
    end

    def report_summary
      response = @request_adapter.get_request(report_summary_address, auth_headers)
      body = JSON.parse(response[:body])
      @total_time = body['total_grand']
      body
    end

    def report_details
      response = @request_adapter.get_request(report_details_address, auth_headers)
      body = JSON.parse(response[:body])
      @total_time = body['total_grand']
      body
    end

    def get_work_start_time(the_day_in_question)
      report = report_details
      time_entry = get_first_time_entry_of_the_day(report)
      # parse_time(time_entry['start'])
      time_entry['start']
    end

    def get_total_work_time(the_day_in_question)
      2 * 3600
    end

    def get_total_time
      @total_time
    end

    private

    def api_token
      File.read('.api_token.secret')
    end

    def workspace_id
      File.read('.workspace_id.secret')
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
      "#{reports_api_base_url}/summary?#{reports_api_params}"
    end

    def report_details_address
      "#{reports_api_base_url}/details?#{reports_api_params}"
    end

    def reports_api_base_url
      'https://toggl.com/reports/api/v2'
    end

    def reports_api_params
      "#{identifying_params}&#{date_params}&#{grouping_params}&rounding=on"
    end

    def identifying_params
      "user_agent=#{@user_agent}&workspace_id=#{@workspace_id}"
    end

    def date_params
      "since=#{@start_date}&until=#{@end_date}"
    end

    def grouping_params
      'grouping=projects&subgrouping=time_entries'
    end

    def auth_headers
      [{ key: 'Authorization', value: basic_auth_token }]
    end

    def get_first_time_entry_of_the_day(report)
      # TODO: this needs to choose the correct entry instead. Could use a project or client argument
      report['data'].first
    end

    def parse_time(toggl_time)
      date_time = toggl_time.split('T')
      date_string = date_time.first
      time_and_zone = date_time.last.split('+')
      time_string = time_and_zone.first
      time_zone_string = '+' + time_and_zone.last
      date_elements = date_string.split('-')
      year = date_elements[0].to_i
      month = date_elements[1].to_i
      day = date_elements[2].to_i
      time_elements = time_string.split(':')
      hour = time_elements[0].to_i
      minute = time_elements[1].to_i
      second = time_elements[2].to_i
      Time.new(year, month, day, hour, minute, second, time_zone_string)
    end
  end
end
