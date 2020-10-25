# frozen_string_literal: true

require_relative 'swap_file.rb'

class Model
  class << self
    attr_reader :fields

    def swap_file
      @swap_file = SwapFile.new to_s if @swap_file&.deleted?

      @swap_file ||= SwapFile.new to_s
    end

    # Integer field initializer
    def int(key, default: 0, presence: false, validation: nil)
      init_field(key, default: default, presence: presence, validation: validation)

      @fields[key][:type] = Integer

      attr_accessor key
    end

    # String field initializer
    def string(key, default: '', presence: false, validation: nil)
      init_field(key, default: default, presence: presence, validation: validation)

      @fields[key][:type] = String

      attr_accessor key
    end

    # Set field initializer
    def set(key, default: ::Set.new, presence: false, validation: proc { |v| v })
      init_field(key, default: default, presence: presence, validation: validation)

      @fields[key][:type] = Set

      attr_accessor key
    end

    # Save record to swap file
    def create(args)
      args[:id] = swap_file.line_count + 1
      obj = new **args
      swap_file.write obj.serialize
      obj
    end

    # Get record from swap file
    def find_by(args)
      swap_file.each do |line|
        line_values = parse_fields line
        return new(**line_values) if args.all? do |key, value|
          line_values[key] &&
          line_values[key] == value
        end
      end
      nil
    end

    # Enumerate records as model objects
    def each
      swap_file.each do |line|
        line_values = parse_fields line
        yield new(**line_values)
      end
    end

    def all
      swap_file.map do |line|
        line_values = parse_fields line
        new(**line_values)
      end
    end

    # Override of default `new` to fill defaults
    def new(args)
      fields.each { |key, value| args[key] ||= value[:default] }

      super(**args)
    end

    def attributes
      fields.keys
    end

    def clear
      swap_file.delete
    end

    private

    # Parse file record to hash
    def parse_fields(line)
      {}.tap do |temp|
        data = line.split(';').map.with_index do |value, i|
          field = fields[fields.keys[i]]

          parse_method = "parse_#{field[:type].to_s.downcase}"
          if respond_to?(parse_method, true)
            send(parse_method.to_s, value)
          else
            value
          end
        end

        attributes.each.with_index do |key, i|
          temp[key] = data[i]
        end
      end
    end

    def parse_integer(str)
      str.to_i
    end

    def parse_set(str)
      Set.new(str.split(','))
    end

    def parse_array(str)
      Array.new(str.split(','))
    end

    def init_field(key, default: nil, presence: false, validation: nil)
      @fields ||= {}
      @fields[key] = { default: default, presence: presence, validation: validation }
    end
  end

  def fields
    self.class.fields
  end

  def attributes
    self.class.attributes
  end

  def validate
    @errors = []
    fields.each do |key, field|
      next if key == :id

      value = send(key)

      if value
        if value.is_a? field[:type]
          errors << "#{key} invalid!" if field[:validation] && field[:validation].call(value) == false
        else
          errors << "#{key} has wrong type!"
        end
      else
        errors << "#{key} is nil!" if field[:presence]
      end
    end
  end

  def valid?
    validate
    errors.empty?
  end

  def errors
    @errors ||= []
  end

  def initialize(args)
    attributes.each do |var_key|
      instance_variable_set :"@#{var_key}", args[var_key]
    end
  end

  # Write record to the end of file or replace other
  def save
    return false unless valid?

    if id
      self.class.swap_file.replace_line id, with: serialize
    else
      self.id = self.class.create(to_h).id
    end
    true
  end

  # Serialize record to string
  def serialize
    attributes.map do |key|
      var = send key
      if var.is_a? Set
        var.to_a.join(',')
      elsif var.is_a? Array
        var.join(',')
      else
        var
      end
    end.join(';')
  end

  def to_h
    {}.tap do |result|
      attributes.each do |attribute_key|
        result[attribute_key] = send attribute_key
      end
    end
  end
end
