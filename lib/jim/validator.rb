module Jim::Validator
	PRIMITIVE_TYPES = [NilClass, TrueClass, FalseClass, Integer, Float, String, Symbol].freeze

	module_function

	def check_nil_or_greater_than_zero(parameter, parameter_name)
		return true if parameter.nil? || parameter.to_f.positive?
		Jim::System.warn "ArgumentError: #{parameter_name} must be nil or greater than zero, but was #{parameter.inspect}"
		false
	end

	def check_nil_or_between_0_and_1(parameter, parameter_name)
		return true if parameter.nil? || parameter.to_f.between?(0, 1)
		Jim::System.warn "ArgumentError: #{parameter_name} must be nil or between 0 and 1, but was #{parameter.inspect}"
		false
	end

	def check_is_symbol(parameter, parameter_name)
		return true if parameter.respond_to?(:to_sym)
		Jim::System.warn "ArgumentError: #{parameter_name} must be a symbol type, but was #{parameter.inspect}"
		false
	end

	def check_is_hash(parameter, parameter_name)
		return true if parameter.is_a?(Hash)
		Jim::System.warn "ArgumentError: #{parameter_name} must be a hash, but was #{parameter.inspect}"
		false
	end

	def check_is_primitive(parameter, parameter_name)
		return true if PRIMITIVE_TYPES.include?(parameter.class)
		Jim::System.warn "ArgumentError: #{parameter_name} must be a primitive type, but was #{parameter.inspect}"
		false
	end
end
