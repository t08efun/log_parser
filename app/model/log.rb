# frozen_string_literal: true

require_relative '../contracts/log_contract'
require_relative '../model'

# The Log class is responsible for keeping logs data and validate it
class Log < Model
  attr_accessor :url, :ip
end
