# frozen_string_literal: true

module Jim::CacheManager
	module_function

	CHECKSUMS_JSON = "checksums.json"
	IMAGE_METADATA_JSON_PATTERN = "metadata/%{sha256}.json"
	IMAGE_FILENAME_PATTERN =
		"%{extension}%{quality}-%{width}x%{height}%{optional_background_postfix}/%{optional_watermark_folder}/%{sha256}.%{extension}"
	SVG_IMAGE_FILENAME_PATTERN = "svg/%{sha256}.%{extension}"
	OPTIONAL_BACKGROUND_POSTFIX_PATTERN = "-b%{background}"
	OPTIONAL_WATERMARK_FOLDER_PATTERN = "%{sha256}-%{width}x%{height}-%{x}-%{y}-%{opacity}"

	def checksums_json = Jim::System.local_cache_path(CHECKSUMS_JSON)

	def image_metadata_json_pattern(source_sha256) = Jim::System.cache_path(IMAGE_METADATA_JSON_PATTERN % { sha256: source_sha256 })

	def image_filename(
		source_sha256:,
		resizing_width:, resizing_height:,
		watermark_sha256: nil, watermark_width: nil, watermark_height: nil,
		watermark_x: nil, watermark_y: nil, watermark_opacity: nil, watermark_is_valid: false,
		output_background: nil, output_extension:, output_is_lossless:, output_quality:
	)
		Jim::System.cache_path(IMAGE_FILENAME_PATTERN % {
			sha256: source_sha256,
			width: resizing_width,
			height: resizing_height,
			optional_watermark_folder: optional_watermark_folder(
				watermark_sha256: watermark_sha256,
				watermark_width: watermark_width,
				watermark_height: watermark_height,
				watermark_x: watermark_x,
				watermark_y: watermark_y,
				watermark_opacity: watermark_opacity,
				watermark_is_valid: watermark_is_valid
			),
			optional_background_postfix: optional_background_postfix(output_background),
			extension: output_extension,
			quality: output_is_lossless ? nil : output_quality
		})
	end

	def svg_image_filename(source_sha256, output_extension)
		Jim::System.cache_path(SVG_IMAGE_FILENAME_PATTERN % { sha256: source_sha256, extension: output_extension })
	end

	private_class_method

	def optional_background_postfix(output_background)
		OPTIONAL_BACKGROUND_POSTFIX_PATTERN % { background: output_background } if output_background
	end

	def optional_watermark_folder(
		watermark_sha256:,
		watermark_width:,
		watermark_height:,
		watermark_x:,
		watermark_y:,
		watermark_opacity:,
		watermark_is_valid:
	)
		OPTIONAL_WATERMARK_FOLDER_PATTERN % {
			sha256: watermark_sha256,
			width: watermark_width,
			height: watermark_height,
			x: watermark_x,
			y: watermark_y,
			opacity: watermark_opacity
		} if watermark_is_valid
	end
end
