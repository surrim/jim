# frozen_string_literal: true

class Jim
	VERSION = "0.3.0"

	def version = Jim::VERSION

	module LiquidFilters
		def jim_version(jim) = jim.version
	end
end
