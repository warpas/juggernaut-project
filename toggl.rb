module Toggl
  class Timer
    def initialize()
      @api_token = api_token
    end

    def api_token
      File.read('.api_token.secret')
    end
  end
end
