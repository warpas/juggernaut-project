require_relative "runner"

module Workflows
  class Weekly
    def self.run
      Workflows::Runner.new(scripts: weekly_scripts).start
    end

    def self.tasks
      weekly_scripts
    end

    def self.weekly_scripts
      [
        "scripts/weekly_work_report.rb"
      ]
    end

    private_class_method :weekly_scripts
  end
end
