# frozen_string_literal: true

require_relative '../model'

# The LogHistory class is responsible for keeping logs data and validate it
class LogHistory < Model
  attr_accessor :url, :ip_set, :id, :count

  class << self
    def add(log)
      history_log = find_by(url: log.url) || new(
        url: log.url,
        count: 0,
        ip_set: Set.new
      )
      history_log.count += 1
      history_log.ip_set.add log.ip

      history_log.save
    end
  end
end
