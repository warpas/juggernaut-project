require_relative "runner"

module Workflows
  class Weekly
    def self.run
      Workflows::Runner.new(scripts: weekly_scripts).start
    end

    def self.tasks
      self.weekly_scripts
    end

    private

    def self.weekly_scripts
      [
        "scripts/weekly_work_report.rb"
      ]
    end
  end
end
