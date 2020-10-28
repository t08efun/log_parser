# frozen_string_literal: true

# Main entry point

require 'dry-validation'

require_relative 'log_file'
require_relative 'mixins/ansi'
require_relative 'model/log'
require_relative 'model/log_history'
require_relative 'services/log_view'

file_path = ARGV.first

begin
  raise 'Missing file path argument' unless file_path

  log_file = LogFile.new file_path
  log_file.each_with_index do |(url, ip), i|
    log = Log.new ip: ip, url: url

    unless log.valid?
      error_message = log.errors.values.join(', ')
      puts ANSI.red("#{i + 1}: #{error_message}")
      next
    end

    LogHistory.add log
  end

  puts LogView.index

  LogHistory.clear
rescue StandardError => e
  puts e.backtrace
  puts "\033[91m#{e.message}\033[39m"
end
