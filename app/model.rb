# frozen_string_literal: true

require_relative 'model/data_file'
require_relative 'contracts/log_contract'
require_relative 'contracts/log_history_contract'

# The Model class is responsible for keeping data
class Model
  class << self
    def data_file
      @data_file ||= DataFile.new(to_s.downcase)
    end

    # Save record to data file
    def create(args)
      args[:id] = data_file.line_count + 1
      obj = new(**args)
      data_file.write obj.serialize
      obj
    end

    # Get record from data file
    def find_by(args)
      data_file.each do |line|
        line_values = parse_fields line
        return new(**line_values) if args.all? do |key, value|
          line_values[key] == value
        end
      end
      nil
    end

    # Enumerate records as model objects
    def each
      data_file.each do |line|
        line_values = parse_fields line
        yield new(**line_values)
      end
    end

    def all
      data_file.map do |line|
        line_values = parse_fields line
        new(**line_values)
      end
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
      data_file.delete
      data_file = nil
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
      self.class.data_file.replace_line id, with: serialize
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
