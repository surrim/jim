# frozen_string_literal: true

module Jim::ImageMetadataManager
  module_function

  def metadata(filename)
    blake3 = Jim::ChecksumManager.blake3(filename)
    image_metadata_json = Jim::CacheManager.image_metadata_json_pattern(blake3)
    if image_metadata_json.exist?
      FileUtils.touch(image_metadata_json)
      return Jim::Utils.read_json_file(image_metadata_json)
    end

    image = Jim::Utils.load_image(filename)
    image_metadata = {
      width: image.columns,
      height: image.rows,
      mime_type: Jim::Utils.mime_type(filename),
      avg_color: image_avg_color(image)
    }
    Jim::Utils.write_json_file(image_metadata_json, image_metadata)
    image_metadata
  end

  private_class_method

  def image_avg_color(image)
    image
      .resize(1, 1)
      .pixel_color(0, 0)
      .to_color(Magick::AllCompliance, true, 8, true)
      .downcase[1..].to_s
  end
end
