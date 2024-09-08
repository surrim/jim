# frozen_string_literal: true

class Jim
	attr_reader :filename_pattern, :svg_filename_pattern

	DEFAULT_FILENAME_PATTERN = "%{pathname}/%{basename}-%{width}.%{format}"
	DEFAULT_SVG_FILENAME_PATTERN = "%{pathname}/%{basename}.%{format}"

	def filename_pattern(filename_pattern)
		@filename_pattern = filename_pattern.nil? \
			? DEFAULT_FILENAME_PATTERN \
			: filename_pattern.to_s
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
		def jim_filename_patterns(jim, filename_pattern, svg_filename_pattern) = jim.filename_patterns(filename_pattern, svg_filename_pattern)
	end
end
