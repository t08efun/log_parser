# frozen_string_literal: true

# Main entry point

require 'set'

require_relative 'file_adapter/log.rb'
require_relative 'services/log_saver.rb'
require_relative 'services/log_view.rb'
require_relative 'model/log.rb'

file_path = ARGV.first

begin
  raise 'Missing file path argument' unless file_path

  file_adapter = FileAdapter::Log.new file_path
  saver = LogSaver.new file_adapter

  unless saver.execute(batch: 1000)
    puts "\033[91mData errors: "
    saver.errors.each { |error| puts error }
    puts "\033[39m"
  end

  puts LogView.index

  Log.clear
rescue StandardError => e
  puts "\033[91m#{e.message}\033[39m"
end
