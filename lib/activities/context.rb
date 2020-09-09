require_relative "log"
require_relative "day_log"
require_relative "category"

module Activities
  def self.show_log_for(date:)
    Activities::Log.list_for(date: date)
  end

  def self.list_categories
    Activities::Category.list
  end

  def self.day_log_entries(date:)
    Activities::DayLog.new(date: date, tracker: Integrations::Toggl::Track).entries
  end
end
