class Jim
	attr_reader :nomarkdown

	DEFAULT_NOMARKDOWN = false

	def nomarkdown(nomarkdown = true)
		@nomarkdown = !!nomarkdown
		self
	end

	module LiquidFilters
		def jim_watermark(jim, nomarkdown = true) = jim.nomarkdown(nomarkdown)
	end
end
