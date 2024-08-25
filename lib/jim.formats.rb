class Jim
	attr_reader :formats

	DEFAULT_FORMATS = []

	def formats(*formats)
		@formats = formats.flatten.map { |format| format&.to_s&.downcase }.uniq
		self
	end

	def append_formats(*formats)
		rm_formats(formats)
		formats(@formats, formats)
	end

	def prepend_formats(*formats)
		rm_formats(formats)
		formats(formats, @formats)
	end

	def rm_formats(*formats)
		formats.flatten.each do |format|
			@formats.delete(format&.to_s&.downcase)
		end
		self
	end

	def rm_all_formats(*formats)
		@formats = []
		self
	end

	module LiquidFilters
		def jim_formats(jim, *formats) = jim.formats(formats)
		def jim_append_formats(jim, *formats) = jim.append_formats(formats)
		def jim_prepend_formats(jim, *formats) = jim.prepend_formats(formats)
		def jim_rm_formats(jim, *formats)= jim.rm_formats(formats)
		def jim_rm_all_formats(jim) = jim.rm_all_formats()
	end
end
