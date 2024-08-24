class Jim
	Dir[File.join(__dir__, "jim", "*.rb")].each { |file| require_relative file }

	attr_reader :src, :alt, :fallback_format, :fallback_width, :filename_pattern, :svg_filename_pattern

	def initialize(
			src, alt = nil,
			fallback_format: nil, fallback_width: nil,
			filename_pattern: nil, svg_filename_pattern: nil
	)
		@src = src.to_s
		@alt = alt&.to_s
		fallback(fallback_format, fallback_width)
		filename_patterns(filename_pattern, svg_filename_pattern)
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

	DEFAULT_FILENAME_PATTERN = "%{pathname}/%{basename}-%{width}.%{format}".freeze
	DEFAULT_SVG_FILENAME_PATTERN = "%{pathname}/%{basename}.%{format}".freeze
	
	def filename_pattern(filename_pattern)
		@filename_pattern = filename_pattern.nil? \
			? DEFAULT_FILENAME_PATTERN \
			: filename_pattern.to_s
		self
	end

	def svg_filename_pattern(svg_filename_pattern)
		@svg_filename_pattern = svg_filename_pattern.nil? \
			? DEFAULT_SVG_FILENAME_PATTERN \
			: svg_filename_pattern.to_s
		self
	end

	def filename_patterns(filename_pattern, svg_filename_pattern)
		filename_pattern(filename_pattern)
		svg_filename_pattern(svg_filename_pattern)
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
