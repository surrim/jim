require 'singleton'

class Jim::ImageMetadataManager
	include Singleton

	IMAGE_METADATA_JSON_PATTERN = "metadata/%{sha256}.json"
	RATIONALIZE_TOLERANCE = 0.005

	def initialize
		@image_metadata_cache = {}
	end

	def all_data(filename)
		sha256 = Jim::ChecksumManager.sha256(filename)
		return {} if sha256.nil?
		return @image_metadata_cache[sha256] if @image_metadata_cache[sha256]

		image_metadata_json = Jim::System.cache_path(IMAGE_METADATA_JSON_PATTERN % { sha256: sha256 })
		if image_metadata_json.exist?
			FileUtils.touch(image_metadata_json)
			return @image_metadata_cache[sha256] = JSON.parse(image_metadata_json.read, { symbolize_names: true })
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

	def width(filename) = all_data(filename)[:width]

	def height(filename) = all_data(filename)[:height]

	def simplified_width(filename) = all_data(filename)[:simplified_width]

	def simplified_height(filename) = all_data(filename)[:simplified_height]

	def mime_type(filename) = all_data(filename)[:mime_type]

	def avg_color(filename) = all_data(filename)[:avg_color]

	def self.all_data(filename) = instance.all_data(filename)

	def self.width(filename) = instance.width(filename)

	def self.height(filename) = instance.height(filename)

	def self.simplified_width(filename) = instance.simplified_width(filename)

	def self.simplified_height(filename) = instance.simplified_height(filename)

	def self.mime_type(filename) = instance.mime_type(filename)

	def self.avg_color(filename) = instance.avg_color(filename)
end
