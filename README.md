# Toggl -> Google Calendar exporter
A simple Ruby script to export time logged through Toggl to Google Calendar

## Work outline

1. Simplest possible export

    - take total time logged yesterday
    - create a single hour-long Google Calendar event on the same day
    - put the duration in the event's description
    - all of the configuration stored in `.<file_name>.secret` files
  
2. Next steps
