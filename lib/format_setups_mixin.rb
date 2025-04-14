# frozen_string_literal: true

module FormatSetupsMixin
  DEFAULT_FORMAT_SETUPS = {
    nil => { quality: 75 }, # default for all mime types
    'image/bmp': { background: 'white' },
    'image/jpeg': { background: 'white', extension: 'jpg' },
    'image/tiff': { background: 'white' }
  }.freeze

  FS_FORMAT             = Jim::Validator.all('String', '.+', 'MimeType')
  FS_KEY_CHOICE         = Jim::Validator.any(:background, :extension, :quality)
  FS_KEY                = Jim::Validator.all('Symbol', '.+', FS_KEY_CHOICE)
  FS_VALUE              = Jim::Validator.any(true, false, Integer, String)
  FS_SETUP              = Jim::Validator.hash(FS_KEY, FS_VALUE, allow_nil_values: true)
  FS_FORMAT_SETUP       = Jim::Validator.hash(FS_FORMAT, FS_SETUP, allow_nil_key: true, allow_nil_values: true)
  FS_SETUP_ARRAY        = Jim::Validator.array(FS_SETUP, allow_nils: true)
  FS_FORMAT_SETUP_ARRAY = Jim::Validator.array(FS_FORMAT_SETUP, allow_nils: true)

  def format_setups(*format_setups, **kw_format_setup)
    format_setups = checked(FS_FORMAT_SETUP_ARRAY, format_setups, :format_setups)
    kw_format_setup = checked(FS_FORMAT_SETUP, kw_format_setup, :kw_format_setup)

    @format_setups = Jim::Utils.deep_merge(*format_setups, kw_format_setup)
  end

  protect_setters(:format_setups)

  def format_setup(format, *setups, **kw_setup)
    merge_format_setup(format, nil, *setups, **kw_setup)
  end

  def format_setting(format, key, value)
    format_setup(format, { key => value })
  end

  def merge_format_setups(*format_setups, **kw_format_setup)
    format_setups(@format_setups, *format_setups, **kw_format_setup)
  end

  def merge_format_setup(format, *setups, **kw_setup)
    format_setups(@format_setups, { format => Jim::Utils.deep_merge(*setups, kw_setup) })
  end

  def reset_format_setups = format_setups(DEFAULT_FORMAT_SETUPS)
end

module Jim::LiquidFilters
  def jim_format_setups(jim, *format_setups) = jim.format_setups(*format_setups)
  def jim_format_setup(jim, format, *setups) = jim.format_setup(format, *setups)
  def jim_format_setting(jim, format, key, value) = jim.format_setting(format, key, value)
  def jim_merge_format_setups(jim, *format_setups) = jim.merge_format_setups(*format_setups)
  def jim_merge_format_setup(jim, format, *setups) = jim.merge_format_setup(format, *setups)
  def jim_reset_format_setups(jim) = jim.reset_format_setups
end
