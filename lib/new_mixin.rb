# frozen_string_literal: true

module NewMixin
  def initialize(src, alt = nil, *presets, **preset_options)
    @src = src.to_s
    @alt = alt&.to_s

    apply_preset = lambda do |preset|
      preset = preset.to_preset if preset.is_a?(Jim)
      preset = preset.to_h unless preset.is_a?(Hash)
      preset.each do |key, value|
        method(key.to_sym).call(value)
      rescue NameError
        Jim::System.info("Ignored preset parameter #{key} = #{value.inspect}")
      end
    end

    apply_preset.call(Jim.hard_coded_preset) # set to valid state
    apply_preset.call(Jim::Utils.deep_merge(
                        Jim.hard_coded_preset,
                        Jim::System.default_preset,
                        *presets.flatten.compact,
                        **preset_options
                      ))
  end
end

module Jim::LiquidFilters
  def jim_new(src, alt = nil, *presets) = Jim.new(src, alt, *presets)
end
