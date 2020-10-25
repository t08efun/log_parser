# frozen_string_literal: true

require_relative '../file_adapter.rb'

class FileAdapter::Log < FileAdapter
  
  private

  def columns
    {
      url: proc { |v| v },
      ips: proc { |v| Set.new [v] }
    }
  end
end
