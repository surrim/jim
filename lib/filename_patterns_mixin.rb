# frozen_string_literal: true

module FilenamePatternsMixin
  DEFAULT_FILENAME_PATTERN = '%{dirname}/%{basename}-%{width}.%{extension}' # rubocop:disable Style/FormatStringToken
  DEFAULT_SVG_FILENAME_PATTERN = '%{dirname}/%{basename}.svgz' # rubocop:disable Style/FormatStringToken

  Jim.setter :filename_pattern, &->(filename_pattern = DEFAULT_FILENAME_PATTERN) do
    assert_all('String', filename_pattern, :filename_pattern)
    @filename_pattern = filename_pattern
  end

  Jim.setter :svg_filename_pattern, &->(svg_filename_pattern = DEFAULT_SVG_FILENAME_PATTERN) do
    return @svg_filename_pattern = nil if svg_filename_pattern.nil?

    assert_all('String', svg_filename_pattern, :svg_filename_pattern)
    @svg_filename_pattern = svg_filename_pattern
  end

  Jim.setter :filename_patterns, &->(filename_pattern, svg_filename_pattern) do
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
