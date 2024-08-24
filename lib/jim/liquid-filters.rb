module Jim::LiquidFilters
	def jim_new(src, alt = nil)
		Jim.new(src, alt)
	end

	def jim_fallback_width(jim, fallback_width)
		jim.fallback_width(fallback_width)
	end
end

Liquid::Template.register_filter(Jim::LiquidFilters)
