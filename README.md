# Toggl -> Google Calendar exporter
A simple Ruby script to export time logged through Toggl to Google Calendar

## Getting started

1. Install Ruby (link to a source on how to do that)
2. Generate Google Calendar credentials in the first step of [their Ruby tutorial](https://developers.google.com/calendar/quickstart/ruby).
    * Enter the name of the App
    * Select "Desktop app"
    * Click on "Download Client Configuration"
    * Move and rename that file as `lib/google/credentials.secret.json`. Alternatively paste those values inside of `lib/google/credentials.secret.json.example` and remove the `.example` extension.
3. Add Toggl config file. Rename `lib/toggl/config.secret.json.example` to `lib/toggl/config.secret.json` and fill the required values. You can get your API token from [Toggl's user profile page](https://toggl.com/app/profile). Make sure it's inside quotation marks.
4. Log some time in Toggl. Default settings work best with yesterday.
5. Run `bundle install`
6. Run `scripts/send_toggl_to_calendar`
7. Check if the entries showed up in your Calendar!

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

    ✅ specify the shape of v1.0

4. Nice to have, but not necessary. Idea bag:

    ✅ add the function for copying all events from one calendar to another calendar

        ✅ add functionality for copying all events for one day between calendars

        ✅ reson: I've got some legacy calendars that I want to get rid of

    ✅ add the option to specify the calendar receiving input without messing with config files

        ✅ add a query for a list of all calendars from Google Calendar if possible

        ✅ check that query. Is it possible?

    ✅ RescueTime API before or after v1.0

    ✅ work weekly report separate from other weekly reports

4. v1.0 release

    - publish it as a gem on RubyGems

    - add it in a different project (Rails app with simple web views)

    - add tests for the main interfaces

    - write clear config steps
        - test app config with a few people
        - streamline Toggl API to require as little config as possible. Probably the API key should be enough.
        - record a short screencast on Google Calendar config steps and paste it here if necessary.
        - make sure Google Calendar and Google Sheets don't override each other's tokens
        - separate credentials from the persistence layer
            - Google Calendar list of calendars shouldn't be stored in credentials file, because it's too much upfront config
            - Same for Google Sheets

6. After v1.0

    - add the option to change calendar entry color

    - move to Github issues after this point (unlikely, but I'll give it a try)

    - integrate Todoist - adding tasks, reading a tasks list at minimum

    - integrate Trello - adding cards at minimum

    - add the option to specify Toggl workspaces

        ✅ fetch workspaces from Toggl

        - do it after UI

    - further Toggl development
        - add a function to list all untagged time entries
        - add a function to tag untagged entry
        - add a function for splitting events that ran past midnight
        - add an Apple Shortcuts automation for splitting events that ran past midnight
