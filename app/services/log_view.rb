# frozen_string_literal: true

require_relative '../model/log.rb'

# The Renderer class is responsible for rendering output strings
class LogView
  class << self
    def index(colorized: true)
      result = []

      Log.each do |log|
        if colorized
          url_string = underline(log.url)
          ips_string = green(log.ips.count)
          count_string = green(log.count)
        else
          url_string = log.url
          ips_string = log.ips.count
          count_string = log.count
        end

        result << "#{url_string} was visited " \
                  "#{count_string} times and there were " \
                  "#{ips_string} unique IPs"
      end
      result.join("\n")
    end

    private

    def underline(str)
      "\e[0;4m#{str}\e[1;0m"
    end

    def white(str)
      "\e[0;97m#{str}\e[1;0m"
    end

    def green(str)
      "\e[0;92m#{str}\e[0;97m"
    end
  end
end
