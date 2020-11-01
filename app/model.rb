# frozen_string_literal: true

require_relative 'contracts/log_contract'
require_relative 'contracts/log_history_contract'

# The Model class is responsible for keeping data
class Model
  class << self
    def create(args)
      args[:id] = storage.count
      obj = new(**args)
      storage << obj
      obj
    end

    def find_by(args)
      storage.each do |obj|
        return obj if args.all? do |key, value|
          obj.send(key) == value
        end
      end
      nil
    end

    def each(&block)
      storage.each(&block)
    end

    def all
      storage
    end

    def contract_class
      Object.const_get("#{self}Contract")
    end

    def fields
      contract_class.fields
    end

    def attributes
      fields.keys
    end

    def clear
      @storage.clear
    end

    def storage
      @storage ||= []
    end

    private

    def parse_fields(line)
      {}.tap do |result|
        data = line.split(';').map.with_index do |value, i|
          field_type = fields[attributes[i]]

          parse_method = "parse_#{field_type.to_s.downcase}"
          if respond_to?(parse_method, true)
            send(parse_method.to_s, value)
          else
            value
          end
        end

        attributes.each.with_index do |key, i|
          result[key] = data[i]
        end
      end
    end

    def parse_integer(str)
      str.to_i
    end

    def parse_set(str)
      Set.new str.split(',')
    end
  end

  def initialize(args)
    @contract_result = contract.call(args)
    attributes.each do |var_key|
      instance_variable_set :"@#{var_key}", args[var_key]
    end
  end

  def attributes
    self.class.attributes
  end

  def contract
    @contract ||= self.class.contract_class.new
  end

  def errors
    @contract_result.errors.to_h
  end

  def valid?
    errors.empty?
  end

  # Write record to the end of file or replace other
  def save
    return false unless valid?

    if id
      self.class.storage[id] = self
    else
      self.id = self.class.create(to_h).id
    end
    true
  end

  # Serialize record to string
  def serialize
    attributes.map do |key|
      var = send key
      case var
      when Set
        var.to_a.join(',')
      when Array
        var.join(',')
      else
        var
      end
    end.join(';')
  end

  def to_h
    attributes.each_with_object({}) do |attribute_key, result|
      result[attribute_key] = send attribute_key
    end
  end
end
