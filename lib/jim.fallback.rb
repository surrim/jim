class Jim
	attr_reader :fallback_format, :fallback_width

	DEFAULT_FALLBACK_FORMAT = nil
	DEFAULT_FALLBACK_WIDTH = nil

	def fallback_format(fallback_format)
		@fallback_format = fallback_format&.to_s&.downcase
		self
	end

	def fallback_width(fallback_width)
		@fallback_width = fallback_width&.to_i \
			if Validator.check_nil_or_greater_than_zero(fallback_width, :fallback_width)
		self
	end

	def fallback(fallback_format, fallback_width)
		fallback_format(fallback_format)
		fallback_width(fallback_width)
	end
	
	module LiquidFilters
		def jim_fallback_format(jim, fallback_format) = jim.fallback_format(fallback_format)
		def jim_fallback_width(jim, fallback_width) = jim.fallback_width(fallback_width)
		def jim_fallback(jim, fallback_format, fallback_width) = jim.fallback(fallback_format, fallback_width)
	end
end
