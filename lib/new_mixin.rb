# frozen_string_literal: true

module NewMixin
  def initialize(src, alt = nil, *presets, **preset_options)
    @src = src.to_s
    @alt = alt&.to_s

    self.class.constants
        .filter { |constant| constant.start_with?('DEFAULT_') }
        .each do |constant|
      method_name = constant['DEFAULT_'.length..].downcase
      default_value = self.class.const_get(constant)
      method(method_name).call(default_value)
    end

    merged_presets = {}.merge(*presets.compact
      .map { |preset| preset.is_a?(Jim) ? preset.to_config_h : preset }
      .map { |preset| preset.is_a?(Hash) ? preset : preset.to_h }
      .map { |preset| preset.transform_keys(&:to_sym) }, preset_options)
    merged_presets.each do |method_name, value|
      method(method_name).call(value)
    rescue NameError
      Jim::System.info("Ignored preset parameter #{method_name} = #{value.inspect}")
    end
  end
end

module Jim::LiquidFilters
  def jim_new(src, alt = nil, *presets) = Jim.new(src, alt, *presets)
end
