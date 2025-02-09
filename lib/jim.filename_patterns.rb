# frozen_string_literal: true

class Jim
  DEFAULT_FILENAME_PATTERN = '%<dirname>s/%<basename>s-%<width>s.%<extension>s'
  DEFAULT_SVG_FILENAME_PATTERN = '%<dirname>s/%<basename>s.svgz'

  def filename_pattern(filename_pattern)
    @filename_pattern = filename_pattern.to_s \
      if Validator.check_is_string(filename_pattern, :filename_pattern)
    self
  end

  def svg_filename_pattern(svg_filename_pattern)
    @svg_filename_pattern = svg_filename_pattern&.to_s
    self
  end

  def filename_patterns(filename_pattern, svg_filename_pattern)
    filename_pattern(filename_pattern)
    svg_filename_pattern(svg_filename_pattern)
  end

  module LiquidFilters
    def jim_filename_pattern(jim, filename_pattern) = jim.filename_pattern(filename_pattern)
    def jim_svg_filename_pattern(jim, svg_filename_pattern) = jim.svg_filename_pattern(svg_filename_pattern)
    def jim_filename_patterns(jim, filename_pattern, svg_filename_pattern) = jim.filename_patterns(filename_pattern, svg_filename_pattern) # rubocop:disable Layout/LineLength
  end
end
