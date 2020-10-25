# frozen_string_literal: true

class FileAdapter
  include Enumerable

  def initialize(path)
    validate path

    @path = path
    @file = File.open @path, 'r'
  end

  def each
    @file.each do |line|
      yield parse_line(line)
    end
  end

  private

  def parse_line(line)
    parsed_values = line.split(' ')

    {}.tap do |result|
      columns.each.with_index do |(key, formatter), i|
        result[key] = formatter.call parsed_values[i]
      end
    end
  end

  # needs override
  def columns
    raise NotImplementedError
  end

  def validate(path)
    raise Errno::ENOENT unless File.exist?(path)
    raise 'Error! File is empty!' unless File.size?(path)
    raise 'Invalid file extension! Available extension: *.log' unless File.extname(path) == '.log'

    true
  end
end
