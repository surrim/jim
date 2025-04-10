# frozen_string_literal: true

module Jim::Validator
  PRIMITIVE_TYPES = [NilClass, TrueClass, FalseClass, Integer, Float, String].freeze

  class << self
    def asserts = @asserts ||= {}

    def define_assert(id, condition, converter = nil)
      asserts[id] = lambda do |parameter, parameter_name|
        if block_given? && !yield(parameter)
          raise ArgumentError, "`#{parameter_name}` must be #{condition}, but was #{parameter.inspect}"
        end

        converter ? converter.call(parameter) : parameter
      end
    end
  end

  def assert_all(*ids, parameter, parameter_name)
    ids.each do |id|
      parameter = Jim::Validator.asserts[id].call(parameter, parameter_name)
    end
    parameter
  end

  def float?(value) = value.is_a?(Numeric) || (value.is_a?(String) && value.match?(/^-?[0-9]+(\.[0-9]*)?$/))
  def int?(value) = value.is_a?(Numeric) || (x.is_a?(String) && x.match?(/^-?[0-9]+$/))
  def mime_type?(value) = Jim::Utils.mime_type2?(value)
  def primitive? = PRIMITIVE_TYPES.include?(x.class)

  def filled_with_optional_positive_ints?(value)
    value.all do |elem|
      elem.nil? || (int?(elem) && elem.to_i.positive?)
    end
  end

  def filled_with_optional_mime_types?(value)
    value.all do |elem|
      elem.nil? || mime_type?(elem)
    end
  end

  def filled_with_string_keys?(value) = value.keys.all { |elem| !elem.nil? }
  def filled_with_primitive_values?(value) = value.values.all { |elem| primitive?(elem) }

  def to_optional_int_values(value) = value.map { |elem| elem&.to_f }
  def to_mime_type(value) = Jim::Utils.auto_convert_mime_type2(value)

  def to_optional_mime_type_values(value)
    value.map do |elem|
      elem.nil? ? nil : to_mime_type(elem)
    end
  end

  def to_string_keys(value) = value.transform_keys(&:to_s)

  define_assert('Primitive', 'nil, true, false, Integer, Float or String', nil, &primitive?)
  define_assert('Float',     'a Float', lambda(&:to_f), &float?)
  define_assert('Integer',   'an Integer', lambda(&:to_i), &int?)
  define_assert('>0',        'greater than zero', nil, &:positive?)
  define_assert('>=0',       'greater or equal than zero') { |x| x >= 0 }
  define_assert('<=1',       'less or equal than one') { |x| x <= 1 }
  define_assert('String',    'a String', lambda(&:to_s)) { |x| !x.nil? }
  define_assert('.+',        'not empty') { |x| !x.empty? }
  define_assert('[a-z]*',    'downcase', lambda(&:downcase))
  define_assert('MimeType',  'a MimeType', to_mime_type, &mime_type?)
  define_assert('Hash',      'a Hash') { |x| x.is_a?(Hash) }
  define_assert('Array',     'a Array') { |x| x.is_a?(Array) }
  define_assert('Bool',      'true or false', ->(x) { x ? true : false })
  define_assert('[Integer>0?]', 'filled with positive Integers or nil values', to_optional_int_values, &filled_with_optional_positive_ints?) # rubocop:disable Layout/LineLength
  define_assert('[MimeType?]', 'filled with MimeTypes or nil values', to_optional_mime_type_values, &filled_with_optional_mime_types?) # rubocop:disable Layout/LineLength
  define_assert('{String,_}', 'filled with String keys', to_string_keys, &filled_with_string_keys?)
  define_assert('{_,Primitive}', 'filled with String or nil values', nil, &filled_with_primitive_values?)
end
