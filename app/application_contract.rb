# frozen_string_literal: true

require 'dry-validation'

# The LogFile class is base contract class
class ApplicationContract < Dry::Validation::Contract
  def self.keys
    fields.keys
  end

  def self.fields
    {}.tap do |result|
      params.type_schema.each do |param|
        result[param.name] = param.primitive
      end
    end
  end
end
