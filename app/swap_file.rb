# frozen_string_literal: true

class SwapFile
  include Enumerable

  attr_reader :line_count, :deleted

  def initialize(name)
    @file_path = "#{__dir__}/swap_files/#{name}"
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
    File.open "#{@file_path}_temp", 'w+' do |file|
      main_file = File.open @file_path, 'r+'
      main_file.each.with_index do |line, i|
        i + 1 == num ? file.puts(with) : file.write(line)
      end
    end
    delete
    File.rename "#{@file_path}_temp", @file_path
  end

  def deleted?
    deleted
  end
end
