# frozen_string_literal: true

module NewMixin
  def initialize(src, alt = nil, *presets, **preset_options)
    # set to valid state
    Jim.preset_constants.each do |preset_constant|
      name = preset_constant[:name]
      constant_value = preset_constant[:constant_value]
      public_send(name, constant_value)
    end

    src(src)
    alt(alt)
    presets(
      Jim::Utils.deep_merge(
        Jim.hard_coded_preset,
        Jim::System.default_preset,
        *presets.flatten.compact.map { |preset| preset.is_a?(Jim) ? preset.to_preset : preset.to_h },
        preset_options
      )
    )
  end

  private

  def src(src)
    assert_all('String', '.+', src, :src)
    @src = src
  end

  def alt(alt)
    return @alt = nil if alt.nil?

    assert_all('String', alt, :alt)
    @alt = alt
  end

  def presets(presets)
    return if presets == Jim.hard_coded_preset

    presets.each do |key, value|
      public_send(key, value)
    rescue NameError
      Jim::System.info("Ignored preset parameter `#{key}` = #{value.inspect}")
    end
  end
end

module Jim::LiquidFilters
  def jim_new(src, alt = nil, *presets) = Jim.new(src, alt, *presets)
end
