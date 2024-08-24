class Jim
	def render
		raise NotImplementedError
	end
	
	module LiquidFilters
		def jim_render(jim)
			jim.render()
		end
	end
end
