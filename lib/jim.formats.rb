# frozen_string_literal: true

class Jim
	attr_reader :formats

	DEFAULT_FORMATS = []

	def formats(*formats)
		@formats = formats.flatten.map { |format| Jim::Utils.auto_convert_mime_type(format) }.uniq
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
			@formats.delete(Jim::Utils.auto_convert_mime_type(format))
		end
		self
	end

	def rm_all_formats
		@formats = []
		self
	end

	module LiquidFilters
		def jim_formats(jim, *formats) = jim.formats(formats)
		def jim_append_formats(jim, *formats) = jim.append_formats(formats)
		def jim_prepend_formats(jim, *formats) = jim.prepend_formats(formats)
		def jim_rm_formats(jim, *formats) = jim.rm_formats(formats)
		def jim_rm_all_formats(jim) = jim.rm_all_formats
	end
end
