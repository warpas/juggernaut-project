# frozen_string_literal: true

# Contexts
require_relative '../lib/activities/context'
require_relative '../lib/analysis/context'
require_relative '../lib/executive/context'
require_relative '../lib/tasks/context'
require_relative '../lib/workflows/context'
require_relative '../lib/integrations/todoist/context'
require_relative '../lib/integrations/toggl/track/context'
require_relative '../lib/interface/context'

# Other
require_relative 'fixtures/reports'
require_relative '../lib/interface/command_line'

# TODO: on their way out
require_relative '../lib/toggl/report'
require_relative '../lib/toggl/google_calendar_adapter'
require_relative '../date_time_helper'
require 'time'
