class Jim
	Dir[File.join(__dir__, "jim", "*.rb")].each { |file| require_relative file }

	attr_reader :src, :alt, :fallback_format, :fallback_width

	def initialize(src, alt = nil, fallback_format: nil, fallback_width: nil)
		@src = src.to_s
		@alt = alt&.to_s
		fallback_format(fallback_format)
		fallback_width(fallback_width)
	end

	def fallback_format(fallback_format)
		@fallback_format = fallback_format&.to_s&.downcase
		self
	end

	def fallback_width(fallback_width)
		@fallback_width = fallback_width&.to_i \
			if Validator::checkNilOrGreaterThanZero(fallback_width, "fallback_width")
		self
	end

	def fallback(fallback_format, fallback_width)
		fallback_format(fallback_format)
		fallback_width(fallback_width)
	end

	def render
		raise NotImplementedError
	end

	def to_h
		{
			:src => @src,
			:alt => @alt,
			:fallback_width => @fallback_width
		}
	end

	def to_s
		to_h.transform_keys(&:to_s).to_s
	end

	def to_liquid
		self
	end

	def to_json
		to_h.to_json
	end
end
