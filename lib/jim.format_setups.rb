class Jim
	attr_reader :format_setups

	DEFAULT_FORMAT_SETUPS = {
		:bmp  => {:background => "white", :lossless => true},
		:jpeg => {:background => "white"},
		:jpg  => {:background => "white"},
		:png  => {:lossless => true},
		:svg  => {:lossless => true},
		:svgz => {:lossless => true},
	}

	def format_setups(*format_setups)
		@format_setups = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
		{}.merge(DEFAULT_FORMAT_SETUPS, *format_setups.compact).each do |format, setup|
			add_format_setup(format, setup)
		end
		self
	end

	def add_format_setup(format, setup)
		setup.each do |key, value|
			add_format_setting(format, key, value)
		end
		self
	end

	def add_format_setting(format, key, value)
		@format_setups[format.to_sym.downcase][key.to_sym.downcase] = value \
			if Validator.check_is_symbol(format, :format) \
			and Validator.check_is_symbol(key, :key) \
			and Validator.check_is_primitive(value, :value)
		self
	end

	def reset_format_setups()
		format_setups()
	end

	module LiquidFilters
		def jim_format_setups(jim, *format_setups) = jim.format_setups(format_setups)
		def jim_add_format_setup(jim, format, setup) = jim.add_format_setup(format, setup)
		def jim_add_format_setting(format, key, value) = jim.add_format_setting(format, key, value)
		def jim_reset_format_setups(jim) = jim.reset_format_setups()
	end
end
