# frozen_string_literal: true

# The InvalidExtension exception
class InvalidExtension < StandardError
  def initialize(message = "'Invalid file extension! Available extension: *.log'")
    super
  end
end
