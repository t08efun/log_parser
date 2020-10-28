# frozen_string_literal: true

require_relative '../application_contract'

# The LogContract class describes Log class attrs
class LogContract < ApplicationContract
  params do
    required(:url).value(:string)
    required(:ip).value(:string)
  end

  rule(:url) do
    key.failure('invalid url!') unless value.match? %r{^(?:/.*)+}
  end

  rule(:ip) do
    key.failure('invalid ip!') unless value.match?(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
  end
end
