# frozen_string_literal: true

module FormatsMixin
  DEFAULT_FORMATS = [].freeze

  F_FORMAT       = Jim::Validator.all('String', '.+', 'MimeType', allow_nil: true)
  F_FORMAT_ARRAY = Jim::Validator.array(F_FORMAT, flatten: true, allow_nils: true, uniq: true)

  def formats(*formats)
    @formats = checked(F_FORMAT_ARRAY, formats, :formats)
  end

  def rm_formats(*formats)
    formats = checked(F_FORMAT_ARRAY, formats, :formats)
    @formats.delete_if { |format| formats.include?(format) }
  end

  protect_setters(:formats, :rm_formats)

  def append_formats(*formats)
    rm_formats(*formats)
    formats(*@formats, *formats)
  end

  def prepend_formats(*formats)
    rm_formats(*formats)
    formats(*formats, *@formats)
  end

  def append_format(format) = append_formats(format)
  def prepend_format(format) = prepend_formats(format)
  def rm_format(format) = rm_formats(format)
  def rm_all_formats = formats
end

module Jim::LiquidFilters
  def jim_formats(jim, *formats) = jim.formats(*formats)
  def jim_rm_formats(jim, *formats) = jim.rm_formats(*formats)
  def jim_append_formats(jim, *formats) = jim.append_formats(*formats)
  def jim_prepend_formats(jim, *formats) = jim.prepend_formats(*formats)
  def jim_append_format(jim, format) = jim.append_format(format)
  def jim_prepend_format(jim, format) = jim.prepend_format(format)
  def jim_rm_format(jim, format) = jim.rm_format(format)
  def jim_rm_all_formats(jim) = jim.rm_all_formats
end
