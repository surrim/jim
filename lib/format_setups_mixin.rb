# frozen_string_literal: true

module FormatSetupsMixin
  DEFAULT_FORMAT_SETUPS = Jim::Utils.deep_stringify_keys(
    {
      '': { quality: 75 },
      'image/bmp': { background: 'white' },
      'image/jpeg': { background: 'white', extension: 'jpg' },
      'image/tiff': { background: 'white' }
    }
  )

  def format_setups(*format_setups)
    @format_setups = {}
    [DEFAULT_FORMAT_SETUPS].concat(format_setups.flatten.compact).reverse.uniq.reverse.each do |format_setup|
      # `reverse.uniq.reverse` removes same format_setups in the right order
      format_setup.each do |format, setup|
        add_format_setup(format, setup)
      end
    end
    self
  end

  def add_format_setup(format, setup)
    if Jim::Validator.check_is_hash(setup, :setup)
      setup.each do |key, value|
        add_format_setting(format, key, value)
      end
    end
    self
  end

  def add_format_setting(format, key, value)
    if Jim::Validator.check_is_primitive(format, :format) \
      && Jim::Validator.check_is_primitive(key, :key) \
      && Jim::Validator.check_is_primitive(value, :value)
      format = Jim::Utils.auto_convert_mime_type(format&.to_s) || format.to_s
      key = key.to_s.downcase
      value = value.to_s if value.is_a?(Symbol)
      if value.nil?
        @format_setups[format].delete(key)
        @format_setups.delete(format) if @format_setups[format].empty?
      else
        @format_setups[format] ||= {}
        @format_setups[format][key] = value
      end
    end
    self
  end

  def reset_format_setups = format_setups
end

module Jim::LiquidFilters
  def jim_format_setups(jim, *format_setups) = jim.format_setups(*format_setups)
  def jim_add_format_setup(jim, format, setup) = jim.add_format_setup(format, setup)
  def jim_add_format_setting(jim, format, key, value) = jim.add_format_setting(format, key, value)
  def jim_reset_format_setups(jim) = jim.reset_format_setups
end
