# frozen_string_literal: true

require_relative '../model/log.rb'

class LogSaver
  attr_accessor :errors

  def initialize(data)
    @data = data
    @errors = []
  end

  def execute(batch: nil)
    logs = []
    count = 0
    @data.each_with_index do |log_data, i|
      if log_index = logs.index { |log| log.url == log_data[:url] }
        logs[log_index].ips.add log_data[:ips].first
        unless logs[log_index].valid?
          add_error i, logs[log_index]
          logs[log_index].ips.delete log_data[:ips].first
        end
        logs[log_index].another_one
      elsif log = Log.find_by(url: log_data[:url])
        log.another_one
        log.ips.add log_data[:ips].first

        add_error i, log unless log.save
      else
        attrs = log_data.slice(*Log.attributes)
        obj = Log.new(**attrs)

        if obj.valid?
          logs << obj
        else
          add_error i, obj
        end
      end

      next unless batch && logs.count == batch

      logs.each(&:save)
      logs.clear
    end

    logs.each(&:save)

    @errors.empty? && true || false
  end

  private

  def add_error(num, obj)
    @errors << "#{num + 1}: #{obj.errors.join(', ')}"
  end
end
