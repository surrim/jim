class Jim
	def render = raise NotImplementedError
	
	module LiquidFilters
		def jim_render(jim) = jim.render()
	end
end
