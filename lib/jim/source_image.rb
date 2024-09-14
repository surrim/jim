# frozen_string_literal: true

class Jim::SourceImage
	attr_reader :src

	SVG_MIME_TYPE = "image/svg+xml"

	def initialize(src)
		@src = src
	end

	def filename = @filename ||= Jim::System.source_path(@src)
	def sha256 = @sha256 ||= Jim::ChecksumManager.sha256(filename)
	def metadata = @metadata ||= Jim::ImageMetadataManager.metadata(filename)
	def width = metadata[:width]
	def height = metadata[:height]
	def simplified_width = metadata[:simplified_width]
	def simplified_height = metadata[:simplified_height]
	def mime_type = metadata[:mime_type]
	def avg_color = metadata[:avg_color]
	def image = @image ||= Jim::Utils.load_image(filename)
	def is_svg? = mime_type == SVG_MIME_TYPE
end
