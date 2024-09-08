require 'singleton'

class Jim::ImageMetadataManager
	include Singleton

	IMAGE_METADATA_JSON_PATTERN = "metadata/%{sha256}.json"

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
		image_metadata = {
			width: image.columns,
			height: image.rows,
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

	def mime_type(filename) = all_data(filename)[:mime_type]

	def avg_color(filename) = all_data(filename)[:avg_color]

	def self.all_data(filename) = instance.all_data(filename)

	def self.width(filename) = instance.width(filename)

	def self.height(filename) = instance.height(filename)

	def self.mime_type(filename) = instance.mime_type(filename)

	def self.avg_color(filename) = instance.avg_color(filename)
end
