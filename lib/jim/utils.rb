# frozen_string_literal: true

require "mime-types"
require "rmagick"

module Jim::Utils
	module_function

	JSON_MODE = JSON::PRETTY_STATE_PROTOTYPE
	SPRINTF_SUBSTITUTION_REGEX = /%{ *(?<identifier>[a-zA-Z_]\w*) *(\[ *(?<from>-?\d+)( *(?<mode>,|..) *(?<to>-?\d+))? *\])? *}/
	SPRINTF_SUBSTITUTION_LIMIT = 16

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
		prepare_folder(filename)
		if use_tmp
			tmp_filename = tmp_filename(filename)
			tmp_filename.write(content)
			FileUtils.mv(tmp_filename, filename)
		else
			filename.write(content)
		end
	end

	def cp_file(source_filename, destination_filename, use_tmp: true)
		prepare_folder(destination_filename)
		if use_tmp
			tmp_filename = tmp_filename(destination_filename)
			FileUtils.cp(source_filename, tmp_filename)
			FileUtils.mv(tmp_filename, destination_filename)
		else
			FileUtils.cp(source_filename, destination_filename)
		end
	end



	def tmp_filename(filename) = filename.dirname + ".#{filename.basename}.tmp"

	def prepare_folder(filename) = FileUtils.mkdir_p(filename.dirname)

	def write_json_file(filename, content, use_tmp: true) = write_file(filename, JSON.generate(content, JSON_MODE), use_tmp: use_tmp)

	def load_image(filename)
		image = Magick::ImageList.new(filename) { |info| info.channel }.auto_orient
		image.strip!
		image
	end

	def mime_type(filename)
		return nil if filename.nil?
		types = MIME::Types.type_for(filename.to_s)
		types.empty? ? Jim::System.error("No MIME type available for #{filename}") : types.first.content_type
	end

	def auto_convert_mime_type(format)
		return nil if format.nil?
		format.to_s.include?("/") ? format.to_s : mime_type(".#{format}")
	end

	def color(color)
		Magick::Pixel.from_color(color).to_color(Magick::AllCompliance, false, 8, true).downcase
	end

	def extension_from_mime_type(mime_type) = MIME::Types[mime_type]&.first&.preferred_extension

	def replace_filename_pattern(filename_pattern, source_image, **substitutions)
		pathname = Pathname.new(source_image.src)
		image_substitutions = {
			sha256: source_image.sha256,
			basename: clean_basename(pathname.basename(pathname.extname).to_s),
			dirname: clean_dirname(pathname.dirname).to_s,
			extension: extension_from_mime_type(source_image.mime_type),
			width: source_image.width,
			height: source_image.height,
			original_dirname: pathname.dirname.to_s,
			original_basename: pathname.basename(pathname.extname).to_s,
			original_extension: pathname.extname[1..-1],
		}
		Jim::System.destination_path(sprintf(filename_pattern, **substitutions, **image_substitutions))
	end

	def sprintf(format_string, **substitutions)
		i = 0
		cycle_counter = 0
		while i < format_string.length do
			break unless format_string.match(SPRINTF_SUBSTITUTION_REGEX, i) do |match|
				match_begin, match_end = match.offset(0)
				identifier = match[:identifier].to_sym
				if !substitutions.has_key?(identifier)
					Jim::System.warn("KeyError: %{#{identifier}} not found, skipping substitution")
					format_string = format_string[0, match_begin] + format_string[match_end..-1]
				elsif cycle_counter >= SPRINTF_SUBSTITUTION_LIMIT
					Jim::System.warn("SubstitutionError: %{#{identifier}} probably causes cyclic dependency, skipping substitution")
					return format_string
				else
					substitution = substitutions[identifier].to_s
					from, mode, to = match[:from], match[:mode], match[:to]
					value = if from.nil?
										substitution
									else
										case mode
										when "," then substitution[from.to_i, to.to_i]
										when ".." then substitution[from.to_i..to.to_i]
										else substitution[from.to_i]
										end
									end
					format_string = format_string[0, match_begin] + value.to_s + format_string[match_end..-1]
				end
				i = match_begin
				cycle_counter += 1
			end
		end
		format_string
	end

	private_class_method

	def clean_dirname(dirname) = Pathname.new(".").join(*dirname.each_filename.map do |basename|
		clean_basename(basename)
	end)

	def clean_basename(basename)
		if %w[_ _. _..].include?(basename)
			Jim::System.warn("SubstitutionError: Preserving leading underscore from \"#{basename}\"")
			return basename
		end
		basename.chr == "_" ? basename[1..-1] : basename
	end
end
