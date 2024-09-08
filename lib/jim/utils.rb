# frozen_string_literal: true

require 'mime-types'
require "rmagick"

module Jim::Utils
	module_function

	JSON_MODE = JSON::PRETTY_STATE_PROTOTYPE

	def deep_stringify_keys(hash)
		result = {}
		hash.each do |key, value|
			result[key.to_s] = value.is_a?(Hash) \
													 ? deep_stringify_keys(value) \
													 : value
		end
		result
	end

	def write_file(filename, content, use_tmp: true)
		FileUtils.mkdir_p(filename.dirname)
		if use_tmp
			tmp_filename = filename.dirname + ".#{filename.basename}.tmp"
			tmp_filename.write(content)
			FileUtils.mv(tmp_filename, filename)
		else
			filename.write(content)
		end
	end

	def write_json_file(filename, content, use_tmp: true) = write_file(filename, JSON.generate(content, JSON_MODE), use_tmp: use_tmp)

	def load_image(filename)
		image = Magick::ImageList.new(filename) { |info| info.channel }.auto_orient
		image.strip!
		image
	end

	def mime_type(filename)
		return nil if filename.nil?
		types = MIME::Types.type_for(filename.to_s)
		types.present? ? types.first.content_type : Jim::System.error("No MIME type available for #{filename}")
	end

	def auto_convert_mime_type(format)
		return nil if format.nil?
		format.to_s.include?("/") ? format.to_s : mime_type(".#{format}")
	end
end
