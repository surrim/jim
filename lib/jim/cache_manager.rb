# frozen_string_literal: true

module Jim::CacheManager
	module_function

	CHECKSUMS_JSON = "checksums.json"
	IMAGE_METADATA_JSON_PATTERN = "metadata/%{sha256}.json"
	IMAGE_FILENAME_PATTERN =
		"%{extension}%{quality}-%{width}x%{height}%{optional_background_postfix}/%{optional_watermark_folder}/%{sha256}.%{extension}"
	SVG_IMAGE_FILENAME_PATTERN = "svg/%{sha256}.%{extension}"
	OPTIONAL_BACKGROUND_POSTFIX_PATTERN = "-b%{background}"
	OPTIONAL_WATERMARK_FOLDER_PATTERN = "%{sha256}}-%{width}x%{height}-%{x}-%{y}}-%{opacity}"

	def checksums_json = Jim::System.local_cache_path(CHECKSUMS_JSON)

	def image_metadata_json_pattern(sha256) = Jim::System.cache_path(IMAGE_METADATA_JSON_PATTERN % { sha256: sha256 })

	def image_filename(sha256, size_property, format_property)
		Jim::System.cache_path(IMAGE_FILENAME_PATTERN % {
			extension: format_property[:extension],
			quality: format_property[:lossless] ? nil : format_property[:quality],
			width: size_property[:width],
			height: size_property[:height],
			optional_background_postfix: optional_background_postfix(format_property[:background]),
			optional_watermark_folder: optional_watermark_folder(size_property[:watermark]),
			sha256: sha256
		})
	end

	def svg_image_filename(source_image, extension)
		Jim::System.cache_path(SVG_IMAGE_FILENAME_PATTERN % {
			extension: extension,
			sha256: source_image.sha256
		})
	end

	private_class_method

	def optional_background_postfix(background)
		OPTIONAL_BACKGROUND_POSTFIX_PATTERN % {
			background: Jim::Utils.color(background)
		} if background
	end

	def optional_watermark_folder(size_watermark_property)
		OPTIONAL_WATERMARK_FOLDER_PATTERN % {
			sha256: size_watermark_property[:source_image].sha256,
			width: size_watermark_property[:width],
			height: size_watermark_property[:height],
			x: size_watermark_property[:x],
			y: size_watermark_property[:y],
			opacity: size_watermark_property[:opacity]
		} if size_watermark_property
	end
end
