# frozen_string_literal: true

class Jim
	attr_reader :format_setups

	DEFAULT_FORMAT_SETUPS = {
		"image/bmp": { background: "white", lossless: true },
		"image/gif": { lossless: true },
		"image/jpeg": { background: "white", extension: "jpg" },
		"image/png": { lossless: true },
		"image/svg+xml": { lossless: true },
		"image/tiff": { background: "white", lossless: true },
		"image/vnd.microsoft.icon": { lossless: true }
	}.freeze
	# quality: 50

	def format_setups(*format_setups)
		reset_format_setups
		{}.merge(*format_setups.compact).each do |format, setup|
			add_format_setup(format, setup)
		end
		self
	end

	def add_format_setup(format, setup)
		setup.each do |key, value|
			add_format_setting(format, key, value)
		end \
			if Validator.check_is_hash(setup, :setup)
		self
	end

	def add_format_setting(format, key, value)
		begin
			format = Jim::Utils.auto_convert_mime_type(format)
			if value.nil?
				@format_setups[format].delete(key.to_s.downcase)
				@format_setups.delete(format) if @format_setups[format].empty?
			else
				@format_setups[format] ||= {}
				@format_setups[format][key.to_s.downcase] = value
			end
		end \
			if Validator.check_is_primitive(format, :format) \
			and Validator.check_is_primitive(key, :key) \
			and Validator.check_is_primitive(value, :value)
		self
	end

	def reset_format_setups
		@format_setups = {}
		DEFAULT_FORMAT_SETUPS.each do |format, setup|
			add_format_setup(format, setup)
		end
		self
	end

	module LiquidFilters
		def jim_format_setups(jim, *format_setups) = jim.format_setups(format_setups)
		def jim_add_format_setup(jim, format, setup) = jim.add_format_setup(format, setup)
		def jim_add_format_setting(jim, format, key, value) = jim.add_format_setting(format, key, value)
		def jim_reset_format_setups(jim) = jim.reset_format_setups
	end
end
