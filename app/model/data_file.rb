# frozen_string_literal: true

# The DataFile class is responsible for saving data to file and editing it
class DataFile
  include Enumerable

  attr_reader :line_count, :deleted

  def initialize(name)
    @file_path = "#{__dir__}/files/#{name}_data"
    File.open(@file_path, 'w').close
    @line_count = 0
    @deleted = false
  end

  def each
    File.open @file_path, 'r+' do |file|
      file.each do |line|
        line.gsub! "\n", ''
        yield line
      end
    end
  end

  def write(str)
    File.open @file_path, 'a+' do |file|
      file.puts str
      @line_count += 1
    end
  end

  def delete
    File.delete @file_path
    @deleted = true
  end

  def replace_line(num, with:)
    main_file = File.open @file_path, 'r+'
    temp_file = File.open "#{@file_path}_temp", 'w+'

    main_file.each.with_index do |line, i|
      (i + 1) == num ? temp_file.puts(with) : temp_file.write(line)
    end
    delete
    File.rename "#{@file_path}_temp", @file_path
    @deleted = false

    main_file.close
    temp_file.close
  end

  def deleted?
    deleted
  end
end
