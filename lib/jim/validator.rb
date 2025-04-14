# frozen_string_literal: true

module Jim::Validator
  class << self
    def named_validators = @named_validators ||= {}

    def validator(name, validate, convert)
      Object.new.tap do |obj|
        obj.define_singleton_method(:name) { name }
        obj.define_singleton_method(:validate) { |object| validate ? validate.call(object) : true }
        obj.define_singleton_method(:convert) { |object| convert ? convert.call(object) : object }
      end
    end

    def name_validator(id, name, validate, convert)
      named_validators[id] = validator(name, validate, convert)
    end

    def to_validator(validator)
      return named_validators[validator] if validator.is_a?(String)
      return validator unless validator.is_a?(Array)

      validator.last.is_a?(Hash) ? all(*validator[0...-1], **validator.last) : all(*validator)
    end

    def to_bool(value) = ![nil, false, 0, '', 'false'].include?(value)
    def to_float(value) = Float(value) rescue nil # rubocop:disable Style/RescueModifier
    def to_mime_type(value) = Jim::Utils.auto_convert_mime_type(value)

    def list_to_string(value0, value1, *more_values, last_separator:)
      values = [value0, value1, *more_values]
      "#{values[0..-2].join(', ')} #{last_separator} #{values[-1]}"
    end

    def all(*validators, allow_nil: false)
      validators = validators.map { |validator| to_validator(validator) }
      return Jim::Validator.validator('something', nil, nil) if validators.empty?
      return validators.first if validators.size == 1

      Jim::Validator.validator(
        list_to_string(*validators.map(&:name), last_separator: 'and'),
        lambda { |x|
          return allow_nil if x.nil?

          validators.each do |validator|
            return false unless validator.validate(x)

            x = validator.convert(x)
          end
          true
        },
        lambda { |x|
          return nil if x.nil?

          validators.each do |validator|
            x = validator.convert(x)
          end
          x
        }
      )
    end

    def any(value0, value1, *more_values)
      values = [value0, value1, *more_values].uniq
      Jim::Validator.validator(
        list_to_string(*values.map(&:inspect), last_separator: 'or'),
        ->(x) { values.any? { |value| value.is_a?(Class) ? x.is_a?(value) : x == value } },
        nil
      )
    end

    def array(validator, flatten: false, compact: false, allow_nils: false, uniq: false, sort: false)
      validator = to_validator(validator)
      Jim::Validator.validator(
        'an Array(' \
          "each value #{validator.name}#{' or nil' if allow_nils}" \
        ')',
        lambda do |x|
          return false unless x.is_a?(Array)

          x = x.flatten if flatten
          x.all? { |value| value.nil? ? allow_nils : validator.validate(value) }
        end,
        lambda do |x|
          x = flatten ? x.flatten : x
          x = compact ? x.compact : x
          x = x.map { |value| value.nil? ? nil : validator.convert(value) }
          x = uniq ? x.uniq : x
          sort ? x.sort(&sort) : x
        end
      )
    end

    def hash(key_validator, value_validator, allow_nil_key: false, allow_nil_values: false)
      key_validator = to_validator(key_validator)
      value_validator = to_validator(value_validator)
      Jim::Validator.validator(
        'a Hash(' \
          "each key #{key_validator.name}#{' or nil' if allow_nil_key}, " \
          "each value #{value_validator.name}#{' or nil' if allow_nil_values}" \
        ')',
        lambda do |x|
          return false unless x.is_a?(Hash)

          x.all? do |key, value|
            (value.nil? ? allow_nil_values : value_validator.validate(value)) &&
            (key.nil? ? allow_nil_key : key_validator.validate(key))
          end
        end,
        lambda do |x|
          x.map do |key, value|
            [key.nil? ? nil : key_validator.convert(key), value.nil? ? nil : value_validator.convert(value)]
          end.to_h
        end
      )
    end
  end

  name_validator('Bool',      'true or false', nil, ->(x) { to_bool(x) })
  name_validator('Integer',   'an Integer', ->(x) { !to_float(x).nil? }, ->(x) { to_float(x).round })
  name_validator('Float',     'a Float', ->(x) { !to_float(x).nil? }, ->(x) { to_float(x) })
  name_validator('>0',        'greater than zero', lambda(&:positive?), nil)
  name_validator('>=0',       'greater or equal than zero', ->(x) { x >= 0 }, nil)
  name_validator('<=1',       'less or equal than one', ->(x) { x <= 1 }, nil)
  name_validator('String',    'a String', nil, lambda(&:to_s))
  name_validator('Symbol',    'a Symbol', nil, ->(x) { x.to_s.to_sym })
  name_validator('.+',        'not empty', ->(x) { !x.empty? }, nil)
  name_validator('[a-z]*',    'downcase', nil, lambda(&:downcase))
  name_validator('MimeType',  'a MimeType', ->(x) { !to_mime_type(x).nil? }, ->(x) { to_mime_type(x) })

  def checked(validator, value, value_name)
    validator = Jim::Validator.to_validator(validator)
    unless validator.validate(value)
      raise ArgumentError, "#{value_name} must be #{validator.name}, but was #{value.inspect}"
    end

    validator.convert(value)
  end
end
