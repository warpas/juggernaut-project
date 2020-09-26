# frozen_string_literal: true

require_relative '../integrations/todoist/context'
require_relative '../maintenance/context'

module Tasks
  def self.list_important
    tasks = Integrations::Todoist.get_tasks_with(label: 'Current_Sprint')
    display(tasks)
  end

  def self.log(string)
    Maintenance::Logger.log_info(message: string)
  end

  def self.display(tasks)
    log "\n🗳  Most important tasks"
    tasks.each do |task|
      log '☑️  ' + task.description
    end
  end

  private_class_method :log
  private_class_method :display
end
