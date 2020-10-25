# frozen_string_literal: true

require_relative '../model.rb'

# The Log class is responsible for keeping logs data and validate it
class Log < Model
  int :id, default: nil
  string :url, default: nil, presence: true, validation: proc { |url| url.match? %r{^(?:/.*)+} }
  int :count, default: 1
  set :ips, default: nil, presence: true, validation: proc { |ips| ips.all? { |ip| ip.match?(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) } }

  def another_one
    self.count += 1
  end
end
