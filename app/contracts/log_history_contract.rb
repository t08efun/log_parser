# frozen_string_literal: true

require_relative '../application_contract'

# The LogHistoryContract class describes LogHistory class attrs
class LogHistoryContract < ApplicationContract
  params do
    optional(:id).value(:integer)
    required(:url).value(:string)
    optional(:count).value(:integer)
    required(:ip_set).value(Dry.Types().Instance(Set))
  end

  rule(:url) do
    key.failure('invalid url!') unless value.match? %r{^(?:/.*)+}
  end

  rule(:ip_set) do
    key.failure('invalid ip_set!') unless value.all? { |ip| ip.match?(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) }
  end
end
