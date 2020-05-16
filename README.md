# Toggl -> Google Calendar exporter
A simple Ruby script to export time logged through Toggl to Google Calendar

## Getting started

1. Generate Google Calendar credentials in the first step of [their Ruby tutorial](https://developers.google.com/calendar/quickstart/ruby). Move and rename that file as `google/credentials.secret.json`. Alternatively paste those values inside of `google/credentials.secret.json.example` and remove the `.example` extension.

2. Add Toggl config file. Rename `toggl/config.secret.json.example` to `toggl/config.secret.json` and fill the required values. You can get your API token from [Toggl's user profile page](https://toggl.com/app/profile).

---

## Work outline

1. Simplest possible export

    ✅ take total time logged yesterday

    ✅ create a single hour-long Google Calendar event on the same day

    ✅ put the duration in the event's description

    ✅ all of the configuration stored in `.<file_name>.secret` files

2. Next step - Improved accuracy

    ✅ create more than one event, preferably with parity between Toggl and Calendar durations

    ✅ figure out how to handle time entries shorter than 15 minutes

    ✅ distinguish between Toggl projects

    ✅ add the option to input date instead of "days ago"

    ✅ add the weekly summary entry for "Work" calendar

3. Next step - Streamlining configuration and release

    ✅ minimize required configuration (too many `*.secret` files now)

    ✅ choose the output calendar according to Toggl time entry tag
        ✅ initialized calendar as a fallback

    ✅ add 'Getting started' section

    ✅ add Google Sheets API auth & basic get call

    ✅ isolate Google APIs auth code from Calendar and Sheets specific code
        ✅ reason: Google Sheets API has most of the same code for auth as Google Calendar API
    ✅ streamline public interfaces
    - add tests
    - specify the shape of v1.0

4. After v1.0

    - move to Github issues after this point (unlikely, because it's unnecessary overhead)

5. Nice to have, but not necessary. Idea bag:

    - add the function for copying all events from one calendar to another calendar
        ✅ add functionality for copying all events for one day between calendars
        - reson: I've got some legacy calendars that I want to get rid of
    - add the ability to specify the calendar receiving input without messing with config files
        - add a query for a list of all calendars from Google Calendar if possible
        - check that query. Is it possible?
    - add the ability to change calendar entry color
    - add the ability to specify Toggl workspaces
    - RescueTime API before or after v1.0
    - probably have separate gems for outside services
    - Write clear config steps
        - Test app config with a few people
        - Streamline Toggl API to require as little config as possible. Probably the API key should be enough.
        - Record a short screencast on Google Calendar config steps and paste it here if necessary.
