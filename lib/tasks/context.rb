# frozen_string_literal: true

require_relative '../integrations/todoist/context'

module Tasks
  def self.list_important
    Integrations::Todoist.get_tasks_with(label: 'Current_Sprint')
  end
end
