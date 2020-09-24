# frozen_string_literal: true

require_relative '../../../toggl/legacy'
require_relative 'time_entry'

module Integrations
  module Toggl
    module Track
      class SummaryReport
        attr_reader :start_date, :end_date

        def initialize(start_date:, end_date: start_date, toggl_connection: LegacyToggl::Report.new)
          @start_date = start_date
          @end_date = end_date
          @toggl_raw_report ||= toggl_connection.report_summary(date: @start_date)
          @summary = @toggl_raw_report['data']
        end

        def self.get_summary_for(date:, client:)
          new(start_date: date).filter_by(client: client)
        end

        def filter_by(client: 'All')
          if client == 'All'
            @summary
          else
            @summary.select do |category|
              category['title']['client'] == client
            end
          end
        end
      end
    end
  end
end
