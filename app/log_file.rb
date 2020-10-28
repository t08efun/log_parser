# frozen_string_literal: true

require_relative 'exceptions/empty_file'
require_relative 'exceptions/invalid_extension'

# The LogFile class is responsible for interacting with log file
class LogFile
  include Enumerable

  def initialize(path)
    validate path

    @path = path
    @file = File.open @path, 'r'
  end

  def each
    @file.each do |line|
      parsed_values = line.split(' ')
      url = parsed_values[0]
      ip = parsed_values[1]

      yield url, ip
    end
  end

  private

  def validate(path)
    raise Errno::ENOENT unless File.exist?(path)
    raise EmptyFile unless File.size?(path)
    raise InvalidExtension unless File.extname(path) == '.log'
  end
end
