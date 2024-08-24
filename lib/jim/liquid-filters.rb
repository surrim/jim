module Jim::LiquidFilters
	def jim_new(src, alt = nil)
		Jim.new(src, alt)
	end

	def fallback_format(jim, fallback_format)
		jim.fallback_format(fallback_format)
	end

	def jim_fallback_width(jim, fallback_width)
		jim.fallback_width(fallback_width)
	end
	
	def jim_fallback(jim, fallback_format, fallback_width)
		jim.fallback(fallback_format, fallback_width)
	end

	def jim_filename_pattern(jim, filename_pattern)
		jim.filename_pattern(filename_pattern)
	end

	def jim_svg_filename_pattern(jim, svg_filename_pattern)
		jim.svg_filename_pattern(svg_filename_pattern)
	end

	def jim_filename_patterns(jim, filename_pattern, svg_filename_pattern)
		jim.filename_patterns(filename_pattern, svg_filename_pattern)
	end
end

Liquid::Template.register_filter(Jim::LiquidFilters)
