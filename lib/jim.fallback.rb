class Jim
	attr_reader :fallback_format, :fallback_width

	def fallback_format(fallback_format)
		@fallback_format = fallback_format&.to_s&.downcase
		self
	end

	def fallback_width(fallback_width)
		@fallback_width = fallback_width&.to_i \
			if Validator::checkNilOrGreaterThanZero(fallback_width, "fallback_width")
		self
	end

	def fallback(fallback_format, fallback_width)
		fallback_format(fallback_format)
		fallback_width(fallback_width)
	end
	
	module LiquidFilters
		def jim_fallback_format(jim, fallback_format)
			jim.fallback_format(fallback_format)
		end

		def jim_fallback_width(jim, fallback_width)
			jim.fallback_width(fallback_width)
		end
		
		def jim_fallback(jim, fallback_format, fallback_width)
			jim.fallback(fallback_format, fallback_width)
		end
	end
end
