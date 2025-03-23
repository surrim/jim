# frozen_string_literal: true

module FallbackMixin
  DEFAULT_FALLBACK_FORMAT = nil
  DEFAULT_FALLBACK_WIDTH = nil

  Jim.setter :fallback_format, &->(fallback_format = DEFAULT_FALLBACK_FORMAT) do
    return @fallback_format = nil if fallback_format.nil?

    assert_all('String', '.+', 'MimeType', fallback_format, :fallback_format)
    @fallback_format = Jim::Utils.auto_convert_mime_type2(fallback_format)
  end

  Jim.setter :fallback_width, &->(fallback_width = DEFAULT_FALLBACK_WIDTH) do
    return @fallback_width = nil if fallback_width.nil?

    assert_all('Numeric', '>0', fallback_width, :fallback_width)
    @fallback_width = fallback_width.to_i
  end

  Jim.setter :fallback, &->(fallback_format, fallback_width) do
    fallback_format(fallback_format)
    fallback_width(fallback_width)
  end
end

module Jim::LiquidFilters
  def jim_fallback_format(jim, fallback_format) = jim.fallback_format(fallback_format)
  def jim_fallback_width(jim, fallback_width) = jim.fallback_width(fallback_width)
  def jim_fallback(jim, fallback_format, fallback_width) = jim.fallback(fallback_format, fallback_width)
end
