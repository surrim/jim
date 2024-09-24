# frozen_string_literal: true

class Jim
  attr_reader :src, :alt

  def initialize(src, alt = nil, **presets)
    @src = src.to_s
    @alt = alt&.to_s

    self.class.constants.filter do |constant|
      constant.start_with? "DEFAULT_"
    end.each do |constant|
      method_name = constant[:DEFAULT_.length..-1].downcase
      default_value = self.class.const_get(constant)
      self.method(method_name).call(default_value)
    end
    presets.each do |method_name, value|
      self.method(method_name).call(value)
    end
  end

  module LiquidFilters
    def jim_new(src, alt = nil, *presets) = Jim.new(src, alt, **{}.merge(*presets.compact))
  end
end
