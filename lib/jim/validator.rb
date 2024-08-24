module Jim::Validator
	module_function

	def checkNilOrGreaterThanZero(parameter, parameter_name)
		return true if parameter.nil? || parameter&.to_i.positive?
		Jim::System.warn "ArgumentError: #{parameter_name} must be nil or greater than zero, but was #{parameter}"
		false
	end
end
