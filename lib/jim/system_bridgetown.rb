module Jim::System
	Bridgetown.initializer :jim do |config|
	end

	module_function

	def warn(text) = Bridgetown.logger.warn("Jim", text)
end if Module.const_defined?(:Bridgetown)
