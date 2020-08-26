require_relative "../maintenance/context"

module Executive
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

    def self.run
      Workflows::Runner.new(scripts: daily_scripts).start
    end

    private

    def log(string)
      Maintenance::Logger.log_info(message: string)
    end
  end
end
