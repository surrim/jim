# frozen_string_literal: true

module FilenamePatternsMixin
  DEFAULT_FILENAME_PATTERN = '%{dirname}/%{basename}-%{width}.%{extension}' # rubocop:disable Style/FormatStringToken
  DEFAULT_SVG_FILENAME_PATTERN = '%{dirname}/%{basename}.svgz' # rubocop:disable Style/FormatStringToken

  FP_FILENAME_PATTERN     = Jim::Validator.all('String', '.+')
  FP_SVG_FILENAME_PATTERN = Jim::Validator.all('String', '.+', allow_nil: true)

  def filename_pattern(filename_pattern)
    @filename_pattern = checked(FP_FILENAME_PATTERN, filename_pattern, :filename_pattern)
  end

  def svg_filename_pattern(svg_filename_pattern)
    @svg_filename_pattern = checked(FP_SVG_FILENAME_PATTERN, svg_filename_pattern, :svg_filename_pattern)
  end

  protect_setters(:filename_pattern, :svg_filename_pattern)

  def filename_patterns(filename_pattern, svg_filename_pattern)
    filename_pattern(filename_pattern)
    svg_filename_pattern(svg_filename_pattern)
  end

  def reset_filename_pattern = filename_pattern(DEFAULT_FILENAME_PATTERN)
  def reset_svg_filename_pattern = svg_filename_pattern(DEFAULT_SVG_FILENAME_PATTERN)
  def reset_filename_patterns = filename_patterns(DEFAULT_FILENAME_PATTERN, DEFAULT_SVG_FILENAME_PATTERN)
end

module Jim::LiquidFilters
  def jim_filename_pattern(jim, filename_pattern) = jim.filename_pattern(filename_pattern)
  def jim_svg_filename_pattern(jim, svg_filename_pattern) = jim.svg_filename_pattern(svg_filename_pattern)
  def jim_filename_patterns(jim, filename_pattern, svg_filename_pattern) = jim.filename_patterns(filename_pattern, svg_filename_pattern) # rubocop:disable Layout/LineLength
  def jim_reset_filename_pattern(jim) = jim.reset_filename_pattern
  def jim_reset_svg_filename_pattern(jim) = jim.reset_svg_filename_pattern
  def jim_reset_filename_patterns(jim) = jim.reset_filename_patterns
end
