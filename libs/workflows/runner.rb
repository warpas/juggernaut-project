require_relative "../interface/command_line"

module Workflows
  class Runner
    def initialize(scripts: [])
      @script_list = scripts
    end

    def start
      iterator = 1
      script_count = @script_list.count
      @script_list.each do |script|
        log "\n⚙️  Running script number #{iterator} / #{script_count}\n"
        load script
        log "\n✅  Script number #{iterator} / #{script_count} ran successfully\n"
        iterator += 1
      end
      log "\n🎉  All scripts within the workflow ran successfully!!"
    end

    private

    attr_reader :script_list

    def log(string)
      Interface::CommandLine.log(string)
    end
  end
end
