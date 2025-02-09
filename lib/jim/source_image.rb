# frozen_string_literal: true

class Jim::SourceImage
  attr_reader :src

  SVG_MIME_TYPE = 'image/svg+xml'

  def initialize(src)
    @src = src
  end

  def filename = @filename ||= Jim::System.source_path(@src)
  def basename = filename.basename(filename.extname).to_s
  def dirname = Pathname.new(@src).dirname.to_s
  def extension = filename.extname[1..].to_s
  def sha256 = @sha256 ||= Jim::ChecksumManager.sha256(filename)
  def metadata = @metadata ||= Jim::ImageMetadataManager.metadata(filename)
  def width = metadata[:width].to_i
  def height = metadata[:height].to_i
  def mime_type = metadata[:mime_type]&.to_s
  def avg_color = metadata[:avg_color].to_s
  def is_svg? = mime_type == SVG_MIME_TYPE
end
