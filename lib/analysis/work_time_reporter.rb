# frozen_string_literal: true

require_relative '../toggl/report'
require_relative '../interface/command_line'
require_relative '../integrations/toggl/track/context'
require_relative '../maintenance/context'
require_relative '../../date_time_helper'
require 'date'

module Analysis
  class WorkTimeReporter
    def self.build_report_for_today
      reporter = WorkTimeReporter.new
      reporter.build_report(date: Date.today)
    end

    def initialize
      @cli = Interface::CommandLine.new(args: ARGV)
    end

    def build_report(date:)
      client_name = @cli.get_runtime_argument(name: 'client', default: 'All')
      filtered_report = tracker.get_summary_for(date: date, client: client_name)
      time_list = filtered_report.map do |category|
        category['time']
      end
      time_in_milliseconds = time_list.sum
      available_hours = get_availability_time_in_hours
      time_to_halfway = calculate_time_to_halfway_point(time_in_milliseconds, available_hours)

      print_availability_message(available_hours)
      print_work_time_message(time_in_milliseconds)
      print_halfway_message(time_to_halfway)
    end

    private

    attr_reader :cli

    def tracker
      Integrations::Toggl::Track
    end

    def log(string)
      Maintenance::Logger.log_info(message: string)
    end

    def calculate_time_to_halfway_point(time, available_hours)
      halfway_point = available_hours / 2
      halfway_point_milliseconds = halfway_point * 3600 * 1000
      halfway_point_milliseconds - time
    end

    def get_availability_time_in_hours
      @cli.get_runtime_argument(name: 'availability', default: 8).to_i
    end

    def print_availability_message(time)
      available_milliseconds = time * 3600 * 1000
      formatted_availability = DateTimeHelper.readable_duration(available_milliseconds)
      log "Availability today: #{formatted_availability}"
    end

    def print_work_time_message(time)
      formatted_time = DateTimeHelper.readable_duration(time)
      log "Worked today for: #{formatted_time}"
    end

    def print_halfway_message(time_left)
      if time_left.positive?
        formatted_halfway = DateTimeHelper.readable_duration(time_left)
        log "Time left until the halfway point today: #{formatted_halfway}"
      else
        log '🎉🎉🎉   Halfway point reached!!  🎉🎉🎉'
      end
    end
  end
end
