# frozen_string_literal: true

module NewMixin
  def initialize(src, alt = nil, *presets, **preset_options)
    @src = src.to_s
    @alt = alt&.to_s

    apply_hard_coded_preset # set to valid state
    hard_coded_preset = to_preset
    merged_presets = Jim::Utils.deep_merge(
      hard_coded_preset,
      Jim::System.default_preset,
      *presets.flatten.compact.map { |preset| preset.is_a?(Jim) ? preset.to_preset : preset.to_h },
      preset_options
    )
    return if merged_presets == hard_coded_preset

    merged_presets.each do |key, value|
      public_send(key, value)
    rescue NameError
      Jim::System.info("Ignored preset parameter #{key} = #{value.inspect}")
    end
  end
end

module Jim::LiquidFilters
  def jim_new(src, alt = nil, *presets) = Jim.new(src, alt, *presets)
end
