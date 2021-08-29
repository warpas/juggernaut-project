require_relative 'runner'

module Workflows
  class CalendarCount
    def self.run
      Workflows::Runner.new(scripts: tasks).start
    end

    def self.tasks
      calendar_count_scripts
    end

    def self.calendar_count_scripts
      [
        'scripts/invoice_abstract.rb'
      ]
    end

    private_class_method :calendar_count_scripts
  end
end
