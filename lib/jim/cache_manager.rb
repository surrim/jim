# frozen_string_literal: true

module Jim::CacheManager
  module_function

  CHECKSUMS_JSON = "checksums.json"
  IMAGE_METADATA_JSON_PATTERN = "metadata/%<sha256>s.json"
  IMAGE_FILENAME_PATTERN =
    "%<extension>s%<quality>s-%<width>sx%<height>s%<optional_background_postfix>s" \
    "/%<optional_watermark_folder>s/%<sha256>s.%<extension>s"
  SVG_IMAGE_FILENAME_PATTERN = "svg/%<sha256>s.%<extension>s"
  OPTIONAL_BACKGROUND_POSTFIX_PATTERN = "-b%<background>s"
  OPTIONAL_WATERMARK_FOLDER_PATTERN = "%<sha256>s-%<width>sx%<height>s-%<x>s-%<y>s-%<opacity>s"

  def checksums_json = Jim::System.local_cache_path(CHECKSUMS_JSON)

  def image_metadata_json_pattern(source_sha256)
    Jim::System.cache_path(format(IMAGE_METADATA_JSON_PATTERN, sha256: source_sha256))
  end

  def image_filename(
    source_sha256:,
    resizing_width:, resizing_height:,
    watermark_sha256: nil, watermark_width: nil, watermark_height: nil,
    watermark_x: nil, watermark_y: nil, watermark_opacity: nil, watermark_is_valid: false,
    output_background: nil, output_extension:, output_is_lossless:, output_quality:
  )
    Jim::System.cache_path(
      format(
        IMAGE_FILENAME_PATTERN,
        sha256: source_sha256, width: resizing_width, height: resizing_height,
        optional_watermark_folder: optional_watermark_folder(
          watermark_sha256:, watermark_width:, watermark_height:,
          watermark_x:, watermark_y:, watermark_opacity:, watermark_is_valid:
        ),
        optional_background_postfix: optional_background_postfix(output_background),
        extension: output_extension,
        quality: output_is_lossless ? nil : output_quality
      )
    )
  end

  def svg_image_filename(source_sha256, output_extension)
    Jim::System.cache_path(format(SVG_IMAGE_FILENAME_PATTERN, sha256: source_sha256, extension: output_extension))
  end

  private_class_method

  def optional_background_postfix(output_background)
    format(OPTIONAL_BACKGROUND_POSTFIX_PATTERN, background: output_background) if output_background
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
    return unless watermark_is_valid

    format(
      OPTIONAL_WATERMARK_FOLDER_PATTERN,
      sha256: watermark_sha256, width: watermark_width, height: watermark_height,
      x: watermark_x, y: watermark_y, opacity: watermark_opacity
    )
  end
end
