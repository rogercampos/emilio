module Emilio
  class EmilioLogger < Logger
    def format_message(severity, timestamp, progname, msg)
      "#{timestamp.to_formatted_s(:db)} #{msg}\n"
    end
  end
end

