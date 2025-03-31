# frozen_string_literal: true

module Jim::Validator
  PRIMITIVE_TYPES = [NilClass, TrueClass, FalseClass, Integer, Float, String].freeze

  class << self
    def asserts = @asserts ||= {}

    def define_assert(id, condition)
      asserts[id] = lambda do |parameter, parameter_name|
        return if yield(parameter)

        raise ArgumentError, "`#{parameter_name}` must be #{condition}, but was #{parameter.inspect}"
      end
    end
  end

  def assert_all(*ids, parameter, parameter_name)
    ids.each do |id|
      Jim::Validator.asserts[id].call(parameter, parameter_name)
    end
  end

  define_assert('Primitive', 'nil, true, false, Integer, Float or String') { |x| PRIMITIVE_TYPES.include?(x.class) }
  define_assert('Numeric',   'a Numeric') { |x| x.is_a?(Numeric) || (x.is_a?(String) && x.match?(/^-?[0-9]*(\.[0-9]*)?$/)) } # rubocop:disable Layout/LineLength
  define_assert('>0',        'greater than zero') { |x| x.to_f > 0 } # rubocop:disable Style/NumericPredicate
  define_assert('>=0',       'greater or equal than zero') { |x| x.to_f >= 0 }
  define_assert('<=1',       'less or equal than one') { |x| x.to_f <= 1 }
  define_assert('String',    'a String') { |x| x.is_a?(String) }
  define_assert('.+',        'not empty') { |x| !x.empty? }
  define_assert('[a-z]*',    'downcase') { |x| x == x.downcase }
  define_assert('MimeType',  'a MimeType') { |x| !Jim::Utils.auto_convert_mime_type2(x).nil? }
  define_assert('Hash',      'a Hash') { |x| x.is_a?(Hash) }
  define_assert('Array',     'a Array') { |x| x.is_a?(Array) }
end
