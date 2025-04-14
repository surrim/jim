# frozen_string_literal: true

module NewMixin
  def initialize(src, alt = nil, *presets, **kw_preset)
    # set to valid state
    Jim.preset_constants.each do |preset_constant|
      name = preset_constant[:name]
      constant_value = preset_constant[:constant_value]
      public_send(name, constant_value)
    end

    src(src)
    alt(alt)
    return if presets.empty? && kw_preset.empty?

    presets(
      Jim::Utils.deep_merge(
        Jim::Utils.deep_stringify_keys(Jim.hard_coded_preset),
        Jim::Utils.deep_stringify_keys(Jim::System.default_preset),
        *presets.flatten.compact.map do |preset|
          Jim::Utils.deep_stringify_keys(preset.is_a?(Jim) ? preset.to_preset : preset.to_h)
        end,
        Jim::Utils.deep_stringify_keys(kw_preset)
      )
    )
  end

  private

  N_SRC = Jim::Validator.all('String', '.+')
  N_ALT = Jim::Validator.all('String', '.+', allow_nil: true)

  def src(src)
    @src = checked(N_SRC, src, :src)
  end

  def alt(alt)
    @alt = checked(N_ALT, alt, :alt)
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
