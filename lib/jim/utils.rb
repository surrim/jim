module Jim::Utils
	module_function

	def deep_stringify_keys(hash)
		result = {}
		hash.each do |key, value|
			result[key.to_s] = value.is_a?(Hash) \
				? deep_stringify_keys(value) \
				: value
		end
		result
	end
end
