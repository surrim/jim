class Jim
	Dir[
		File.join(__dir__, "*.rb"),
		File.join(__dir__, "jim", "*.rb")
	].each { |file| require_relative file }

	Liquid::Template.register_filter(LiquidFilters)

	def to_h
		{
			:src => @src,
			:alt => @alt,
			:fallback_format => @fallback_format,
			:fallback_width => @fallback_width,
			:filename_pattern => @filename_pattern,
			:svg_filename_pattern => @svg_filename_pattern,
		}
	end

	def to_s
		to_h.transform_keys(&:to_s).to_s
	end

	def to_liquid
		self
	end

	def to_json
		to_h.to_json
	end
end
