# frozen_string_literal: true

module FilenamePatternsMixin
  DEFAULT_FILENAME_PATTERN = '%{dirname}/%{basename}-%{width}.%{extension}' # rubocop:disable Style/FormatStringToken
  DEFAULT_SVG_FILENAME_PATTERN = '%{dirname}/%{basename}.svgz' # rubocop:disable Style/FormatStringToken

  def filename_pattern(filename_pattern = DEFAULT_FILENAME_PATTERN)
    @filename_pattern = assert_all('String', '.+', filename_pattern, :filename_pattern)
  end

  def svg_filename_pattern(svg_filename_pattern = DEFAULT_SVG_FILENAME_PATTERN)
    return @svg_filename_pattern = nil if svg_filename_pattern.nil?

    @svg_filename_pattern = assert_all('String', '.+', svg_filename_pattern, :svg_filename_pattern)
  end

  protect_setters(:filename_pattern, :svg_filename_pattern)

  def filename_patterns(filename_pattern, svg_filename_pattern)
    filename_pattern(filename_pattern)
    svg_filename_pattern(svg_filename_pattern)
  end
end

module Jim::LiquidFilters
  def jim_filename_pattern(jim, filename_pattern) = jim.filename_pattern(filename_pattern)
  def jim_svg_filename_pattern(jim, svg_filename_pattern) = jim.svg_filename_pattern(svg_filename_pattern)

  def jim_filename_patterns(
    jim,
    filename_pattern,
    svg_filename_pattern
  ) = jim.filename_patterns(filename_pattern, svg_filename_pattern)
end
