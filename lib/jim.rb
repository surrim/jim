class Jim
	Dir[
		File.join(__dir__.to_s, "*.rb"),
		File.join(__dir__.to_s, "jim", "*.rb")
	].each { |file| require_relative file }

	Liquid::Template.register_filter(LiquidFilters)

	def to_h
		h = { src: @src, alt: @alt }
		self.class.constants.filter do |constant|
			constant.start_with? "DEFAULT_"
		end.each do |constant|
			name = constant[:DEFAULT_.length..-1].downcase
			value = self.instance_variable_get("@#{name}")
			h[name.to_sym] = value
		end
		h
	end

	def to_s = Utils.deep_stringify_keys(to_h).to_s
	def to_liquid = self
	def to_json(opts = nil) = to_h.to_json(opts)
end
