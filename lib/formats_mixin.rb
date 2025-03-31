# frozen_string_literal: true

module FormatsMixin
  DEFAULT_FORMATS = [].freeze

  def assert_valid_format(format)
    return if format.nil?

    assert_all('String', '.+', 'MimeType', format, :format)
  end

  def assert_valid_formats(formats)
    assert_all('Array', formats, :formats)
    formats.each do |format|
      assert_valid_format(format)
    end
  end

  def formats(*formats)
    formats = formats.flatten
    assert_valid_formats(formats)
    formats = formats.map { |format| Jim::Utils.auto_convert_mime_type2(format) }.uniq
    @formats = formats
  end

  def rm_formats(*formats)
    formats = formats.flatten
    assert_valid_formats(formats)
    formats = formats.map { |format| Jim::Utils.auto_convert_mime_type2(format) }.uniq
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

  def rm_all_formats = formats
end

module Jim::LiquidFilters
  def jim_formats(jim, *formats) = jim.formats(*formats)
  def jim_rm_formats(jim, *formats) = jim.rm_formats(*formats)
  def jim_append_formats(jim, *formats) = jim.append_formats(*formats)
  def jim_prepend_formats(jim, *formats) = jim.prepend_formats(*formats)
  def jim_rm_all_formats(jim) = jim.rm_all_formats
end
