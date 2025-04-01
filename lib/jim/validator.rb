# frozen_string_literal: true

module Jim::Validator
  PRIMITIVE_TYPES = [NilClass, TrueClass, FalseClass, Integer, Float, String].freeze

  class << self
    def asserts = @asserts ||= {}

    def define_assert(id, condition, converter = nil)
      asserts[id] = lambda do |parameter, parameter_name|
        return converter ? converter.call(parameter) : parameter if !block_given? || yield(parameter)

        raise ArgumentError, "`#{parameter_name}` must be #{condition}, but was #{parameter.inspect}"
      end
    end
  end

  def assert_all(*ids, parameter, parameter_name)
    ids.each do |id|
      parameter = Jim::Validator.asserts[id].call(parameter, parameter_name)
    end
    parameter
  end

  define_assert('Primitive', 'nil, true, false, Integer, Float or String') { |x| PRIMITIVE_TYPES.include?(x.class) }
  define_assert('Float',     'a Float', lambda(&:to_f)) { |x| x.is_a?(Numeric) || (x.is_a?(String) && x.match?(/^-?[0-9]+(\.[0-9]*)?$/)) } # rubocop:disable Layout/LineLength
  define_assert('Integer',   'an Integer', lambda(&:to_i)) { |x| x.is_a?(Numeric) || (x.is_a?(String) && x.match?(/^-?[0-9]+$/)) } # rubocop:disable Layout/LineLength
  define_assert('>0',        'greater than zero') { |x| x > 0 } # rubocop:disable Style/NumericPredicate
  define_assert('>=0',       'greater or equal than zero') { |x| x >= 0 }
  define_assert('<=1',       'less or equal than one') { |x| x <= 1 }
  define_assert('String',    'a String', lambda(&:to_s)) { |x| !x.nil? }
  define_assert('.+',        'not empty') { |x| !x.empty? }
  define_assert('[a-z]*',    'downcase', lambda(&:downcase))
  define_assert('MimeType',  'a MimeType', ->(x) { Jim::Utils.auto_convert_mime_type2(x) }) { |x| !Jim::Utils.auto_convert_mime_type2(x).nil? } # rubocop:disable Layout/LineLength
  define_assert('Hash',      'a Hash') { |x| x.is_a?(Hash) }
  define_assert('Array',     'a Array') { |x| x.is_a?(Array) }
  define_assert('Bool',      'true or false', ->(x) { x ? true : false })
end
