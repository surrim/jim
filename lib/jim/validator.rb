module Jim::Validator
	module_function

	def checkNilOrGreaterThanZero(parameter, parameter_name)
		return true if parameter.nil? || parameter&.to_i.positive?
		Jim::System.warn "ArgumentError: #{parameter_name} must be nil or greater than zero, but was #{parameter}"
		false
	end

	def checkSymbolType(parameter, parameter_name)
		return true if parameter.respond_to?(:to_sym)
		Jim::System.warn "ArgumentError: #{parameter_name} must be a symbol type, but was #{parameter}"
		false
	end

	def checkPrimitiveType(parameter, parameter_name)
		return true unless parameter.respond_to?(:each)
		Jim::System.warn "ArgumentError: #{parameter_name} must be a primitive type, but was #{parameter}"
		false
	end
end
