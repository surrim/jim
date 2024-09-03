class Jim
	def render(_render = true) = raise(NotImplementedError)

	module LiquidFilters
		def jim_render(jim, render = true) = jim.render(render)
	end
end
