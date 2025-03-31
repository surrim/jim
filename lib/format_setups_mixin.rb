# frozen_string_literal: true

module FormatSetupsMixin
  DEFAULT_FORMAT_SETUPS = Jim::Utils.deep_stringify_keys(
    {
      'image/bmp': { background: 'white' },
      'image/jpeg': { background: 'white', extension: 'jpg' },
      'image/tiff': { background: 'white' }
    }
  )
  DEFAULT_DEFAULT_FORMAT_SETUP = Jim::Utils.deep_stringify_keys( # default for all mime types
    { quality: 75 }
  )

  def assert_valid_format(format) = assert_all('String', '.+', 'MimeType', format, :format)
  def assert_valid_key(key) = assert_all('String', '.+', '[a-z]*', key, :key)
  def assert_valid_value(value) = assert_all('Primitive', value, :value)

  def assert_valid_setup(setup)
    return if setup.nil?

    assert_all('Hash', setup, :setup)
    setup.each do |key, value|
      assert_valid_key(key)
      assert_valid_value(value)
    end
  end

  def assert_valid_format_setups(format_setups)
    return if format_setups.nil?

    assert_all('Hash', format_setups, :format_setups)
    format_setups.each do |format, setup|
      assert_valid_format(format)
      assert_valid_setup(setup)
    end
  end

  def format_setups(*format_setups, **kw_format_setup)
    merged_format_setups = Jim::Utils.deep_merge(*format_setups, kw_format_setup)
    assert_valid_format_setups(merged_format_setups)
    merged_format_setups = merged_format_setups.transform_keys { |format| Jim::Utils.auto_convert_mime_type2(format) }
    @format_setups = merged_format_setups
  end

  def format_setup(format, *setups, **kw_setup)
    merged_setup = Jim::Utils.deep_merge(*setups, kw_setup)
    assert_valid_format(format)
    assert_valid_setup(merged_setup)
    format = Jim::Utils.auto_convert_mime_type2(format)
    @format_setups = Jim::Utils.deep_merge(@format_setups, { format => nil }, { format => merged_setup })
  end

  def format_setting(format, key, value)
    assert_valid_format(format)
    assert_valid_key(key)
    assert_valid_value(value)
    format = Jim::Utils.auto_convert_mime_type2(format)
    @format_setups = Jim::Utils.deep_merge(@format_setups, { format => { key => value } })
  end

  def default_format_setup(*setups, **kw_setup)
    merged_setup = Jim::Utils.deep_merge(*setups, kw_setup)
    assert_valid_setup(merged_setup)
    @default_format_setup = merged_setup
  end

  def default_format_setting(key, value)
    assert_valid_key(key)
    assert_valid_value(value)
    @default_format_setup = Jim::Utils.deep_merge(@default_format_setup, { key => value })
  end

  protect_setters(:format_setups, :format_setup, :format_setting, :default_format_setup, :default_format_setting)

  def merge_format_setups(*format_setups, **kw_format_setup)
    format_setups(@format_setups, *format_setups, **kw_format_setup)
  end

  def merge_format_setup(format, *setups, **kw_setup)
    assert_valid_format(format)
    format = Jim::Utils.auto_convert_mime_type2(format)
    format_setup(format, @format_setups[format], *setups, **kw_setup)
  end

  def merge_default_format_setup(*setups, **kw_setup)
    default_format_setup(@default_format_setup, *setups, **kw_setup)
  end

  def reset_format_setups = format_setups(DEFAULT_FORMAT_SETUPS)
  def reset_default_format_setup = default_format_setup(DEFAULT_DEFAULT_FORMAT_SETUP)
end

module Jim::LiquidFilters
  def jim_format_setups(jim, *format_setups) = jim.format_setups(*format_setups)
  def jim_format_setup(jim, format, *setups) = jim.format_setup(format, *setups)
  def jim_format_setting(jim, format, key, value) = jim.format_setting(format, key, value)
  def jim_default_format_setup(jim, *setups) = jim.default_format_setup(*setups)
  def jim_default_format_setting(jim, key, value) = jim.default_format_setting(key, value)
  def jim_merge_format_setups(jim, *format_setups) = jim.merge_format_setups(*format_setups)
  def jim_merge_format_setup(jim, format, *setups) = jim.merge_format_setup(format, *setups)
  def jim_merge_default_format_setup(jim, *setups) = jim.merge_default_format_setup(*setups)
  def jim_reset_format_setups(jim) = jim.reset_format_setups
  def jim_reset_default_format_setup(jim) = jim.reset_default_format_setup
end
