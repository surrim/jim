class Jim
	attr_reader :src, :alt

	def initialize(
			src, alt = nil,
			fallback_format: nil, fallback_width: nil,
			filename_pattern: nil, svg_filename_pattern: nil,
			formats: []
	)
		@src = src.to_s
		@alt = alt&.to_s
		fallback(fallback_format, fallback_width)
		filename_patterns(filename_pattern, svg_filename_pattern)
		rm_formats()
		formats(formats)
	end

	module LiquidFilters
		def jim_new(src, alt = nil)
			Jim.new(src, alt)
		end
	end
end
