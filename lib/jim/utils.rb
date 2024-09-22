# frozen_string_literal: true

require "mime-types"
require "rmagick"

module Jim::Utils
	module_function

	JSON_MODE = JSON::PRETTY_STATE_PROTOTYPE
	LOSSLESS_MIME_TYPES = %w[image/bmp image/gif image/png image/svg+xml image/tiff image/vnd.microsoft.icon].freeze
	SPRINTF_SUBSTITUTION_REGEX = /%{ *(?<identifier>[a-zA-Z_]\w*) *(\[ *(?<from>-?\d+)( *(?<mode>,|..) *(?<to>-?\d+))? *\])? *}/
	SPRINTF_SUBSTITUTION_LIMIT = 16

	def deep_stringify_keys(hash)
		result = {}
		hash.each do |key, value|
			result[key.to_s] = value.is_a?(Hash) ? deep_stringify_keys(value) : value
		end
		result
	end

	def write_file(filename, content = nil)
		prepare_folder(filename)
		tmp_filename = tmp_filename(filename)
		block_given? ? yield(tmp_filename) : tmp_filename.write(content)
		FileUtils.mv(tmp_filename, filename)
	end

	def write_file_if_not_exist(filename, content = nil, &block)
		if filename.exist?
			FileUtils.touch(filename)
		else
			block_given? ? write_file(filename, content, &block) : write_file(filename, content)
		end
		filename
	end

	def read_json_file(filename) = JSON.parse(filename.read, { symbolize_names: true })

	def write_json_file(filename, content) = write_file(filename, JSON.generate(content, JSON_MODE))

	def load_image(filename)
		image = Magick::ImageList.new(filename) { |info| info.channel }.auto_orient
		image.strip!
		image
	end

	def color(color)
		return nil if color.nil?
		Magick::Pixel.from_color(color).to_color(Magick::AllCompliance, false, 8, true).downcase
	end

	def mime_type(filename)
		return nil if filename.nil?
		types = MIME::Types.type_for(filename.to_s)
		types.empty? ? Jim::System.error("MimeTypeError: No type available for #{filename}") : types.first.content_type
	end

	def is_lossless_mime_type?(mime_type) = LOSSLESS_MIME_TYPES.include?(mime_type)

	def preferred_extension_for_mime_type(mime_type) = MIME::Types[mime_type]&.first&.preferred_extension

	def auto_convert_mime_type(format) = format.include?("/") ? format : mime_type(".#{format}")

	def replace_filename_pattern(
		filename_pattern, user_substitutions,
		source_sha256:, source_extension:, source_dirname:, source_basename:,
		resizing_width:, resizing_height:,
		output_extension:, output_background:, output_is_lossless:, output_quality:
	)
		substitutions = {
			sha256: source_sha256,
			dirname: clean_dirname(source_dirname),
			basename: clean_basename(source_basename),
			original_dirname: source_dirname,
			original_basename: source_basename,
			original_extension: source_extension,
			width: resizing_width,
			height: resizing_height,
			extension: output_extension,
			background: output_background,
			quality: output_is_lossless ? nil : output_quality,
		}
		Jim::System.destination_path(sprintf(filename_pattern, **user_substitutions, **substitutions))
	end

	private_class_method

	def tmp_filename(filename) = filename.dirname + ".#{filename.basename}.tmp"

	def prepare_folder(filename) = FileUtils.mkdir_p(filename.dirname)

	def clean_dirname(dirname) = Pathname.new(".").join(*Pathname.new(dirname).each_filename.map do |basename|
		clean_basename(basename)
	end).to_s

	def clean_basename(basename)
		if %w[_ _. _..].include?(basename)
			Jim::System.warn("SubstitutionError: Preserving leading underscore from \"#{basename}\"")
			return basename
		end
		basename.chr == "_" ? basename[1..-1] : basename
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
end
