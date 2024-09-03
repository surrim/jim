class Jim
	attr_reader :substitutions

	DEFAULT_SUBSTITUTIONS = {}

	def substitutions(*substitutions)
		rm_substitutions
		{}.merge(*substitutions.compact).each { |key, value|
			add_substitution(key, value)
		}
		self
	end

	def add_substitution(key, value)
		if value.nil?
			@substitutions.delete(key.to_s)
		else
			@substitutions[key.to_s] = value.to_s
		end
		self
	end

	def rm_substitution(key) = add_substitution(key, nil)

	def rm_substitutions
		@substitutions = {}
		self
	end

	module LiquidFilters
		def jim_substitutions(jim, *substitutions) = jim.substitutions(jim, substitutions)
		def jim_add_substitution(jim, key, value) = jim.add_substitution(key, value)
		def jim_rm_substitution(jim, key) = jim.rm_substitution(key)
		def jim_rm_substitutions(jim) = jim.rm_substitutions
	end
end
