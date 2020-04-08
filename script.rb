require_relative 'Toggl'
require_relative 'Google'

def readable_time(time)
  "5 hours, 17 minutes and 42 seconds"
end

def build_calendar_entry
  toggl = Toggl::Timer.new
  toggl.print_config
  toggl.authorize

  time = Time.now
  one_day = 86400
  yesterday = time - one_day
  work_start_time_yesterday = toggl.get_work_start_time(yesterday)
  half_an_hour = 1800
  title = "Work for Rebased"
  work_time_yesterday = toggl.get_total_work_time(yesterday)
  human_readable_work_time_yesterday = readable_time(work_time_yesterday)
  description = "Time: #{human_readable_work_time_yesterday}\nProject: Harmonogram"

  {
    start: work_start_time_yesterday,
    duration: half_an_hour,
    title: title,
    description: description,
  }
end

calendar = Google::Calendar.new
calendar.add_work_entry(build_calendar_entry)
