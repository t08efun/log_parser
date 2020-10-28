# frozen_string_literal: true

require_relative '../model/log'
require_relative '../mixins/ansi'

# The LogView class is responsible for rendering output strings
class LogView
  class << self
    def index(colorized: true)
      result = []

      LogHistory.each do |log_history|
        if colorized
          url_string = ANSI.underline(log_history.url)
          ips_string = ANSI.green(log_history.ip_set.count)
          count_string = ANSI.green(log_history.count)
        else
          url_string = log_history.url
          ips_string = log_history.ip_set.count
          count_string = log_history.count
        end

        result << "#{url_string} was visited " \
                  "#{count_string} times and there were " \
                  "#{ips_string} unique IPs"
      end
      result.join("\n")
    end
  end
end
