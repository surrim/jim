# frozen_string_literal: true

module FallbackMixin
  DEFAULT_FALLBACK_FORMAT = nil
  DEFAULT_FALLBACK_WIDTH = nil

  F_FORMAT = Jim::Validator.all('String', '.+', 'MimeType', allow_nil: true)
  F_WIDTH  = Jim::Validator.all('Integer', '>0', allow_nil: true)

  def fallback_format(fallback_format = DEFAULT_FALLBACK_FORMAT)
    @fallback_format = checked(F_FORMAT, fallback_format, :fallback_format)
  end

  def fallback_width(fallback_width = DEFAULT_FALLBACK_WIDTH)
    @fallback_width = checked(F_WIDTH, fallback_width, :fallback_width)
  end

  protect_setters(:fallback_format, :fallback_width)

  def fallback(fallback_format, fallback_width)
    fallback_format(fallback_format)
    fallback_width(fallback_width)
  end
end

module Jim::LiquidFilters
  def jim_fallback_format(jim, fallback_format = DEFAULT_FALLBACK_FORMAT) = jim.fallback_format(fallback_format)
  def jim_fallback_width(jim, fallback_width = DEFAULT_FALLBACK_WIDTH) = jim.fallback_width(fallback_width)
  def jim_fallback(jim, fallback_format, fallback_width) = jim.fallback(fallback_format, fallback_width)
end
