require_relative 'Toggl'
require_relative 'Google'

def readable_time(time)
  "5 hours, 17 minutes and 42 seconds"
end

def client_name
  File.read('.client_name.secret')
end

def project_name
  File.read('.project_name.secret')
end

def build_calendar_entry
  toggl = Toggl::Timer.new
  toggl.print_config
  toggl.authorize

  time = Time.now
  one_day = 86400
  yesterday = time - one_day
  work_start_time_yesterday = toggl.get_work_start_time(yesterday)
  one_hour = 3600
  title = "Work for #{client_name}"
  work_time_yesterday = toggl.get_total_work_time(yesterday)
  human_readable_work_time_yesterday = readable_time(work_time_yesterday)
  description = "Time: #{human_readable_work_time_yesterday}\nProject: #{project_name}"

  {
    start: work_start_time_yesterday,
    duration: one_hour,
    title: title,
    description: description,
  }
end

calendar = Google::Calendar.new
calendar.add_work_entry(build_calendar_entry)
