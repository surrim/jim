# frozen_string_literal: true

module Jim::ImageMetadataManager
	module_function

	RATIONALIZE_TOLERANCE = 0.005

	def metadata(filename)
		sha256 = Jim::ChecksumManager.sha256(filename)
		return {} if sha256.nil?

		image_metadata_json = Jim::PathManager.image_metadata_json_pattern(sha256)
		if image_metadata_json.exist?
			FileUtils.touch(image_metadata_json)
			return JSON.parse(image_metadata_json.read, { symbolize_names: true })
		end

		image = Jim::Utils::load_image(filename)
		width = image.columns
		height = image.rows
		ratio = (width.to_f / height).rationalize(RATIONALIZE_TOLERANCE)
		simplified_width = ratio.numerator
		simplified_height = ratio.denominator
		image_metadata = {
			width: width,
			height: height,
			simplified_width: simplified_width,
			simplified_height: simplified_height,
			mime_type: Jim::Utils.mime_type(filename),
			avg_color: image
									 .resize(1, 1)
									 .pixel_color(0, 0)
									 .to_color(Magick::AllCompliance, true, 8, true)
									 .downcase
		}
		Jim::Utils.write_json_file(image_metadata_json, image_metadata)
		image_metadata
	end
end
