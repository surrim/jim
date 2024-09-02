module Jim::System
	module_function

	def warn(text) = Jekyll.logger.warn("Jim", text)
end if Module.const_defined?(:Jekyll)
