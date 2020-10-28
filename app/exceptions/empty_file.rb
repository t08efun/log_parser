# frozen_string_literal: true

# The EmptyFile exception
class EmptyFile < StandardError
  def initialize(message = 'File is empty!')
    super
  end
end
