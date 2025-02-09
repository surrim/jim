# frozen_string_literal: true

require 'zlib'
require_relative 'utils'

class Jim::SvgSourceImage
  XML_DECLARATION_REGEX = /\s*<\?xml(\s+\w+=('[^']*'|"[^"]*"))+\s*\?>\s*/
  XML_DOCTYPE_REGEX = /\s*<!DOCTYPE[^>\[]*(\[[^\]]*\])?>\s*/
  XML_COMMENT_REGEX = /\s*<!--.*-->\s*/

  def initialize(filename, sha256)
    @filename = filename
    @sha256 = sha256
  end

  def compressed? = @compressed ||= @filename.to_s.downcase.end_with?('.svgz')
  def convert(compress) = compress ? convert_to_svgz : convert_to_svg
  def convert_to_svg = convert_to('svg', svg_content)
  def convert_to_svgz = convert_to('svgz', svgz_content)
  def convert_to_inline_svg = convert_to('inline_svg', inline_svg_content)

  private

  def content = @filename.read
  def svg_content = compressed? ? ungzip(content) : content
  def svgz_content = compressed? ? content : gzip(content)

  def inline_svg_content = svg_content
    .sub(XML_DECLARATION_REGEX, '')
    .sub(XML_DOCTYPE_REGEX, '')
    .sub(XML_COMMENT_REGEX, '')

  def ungzip(content) = Zlib::GzipReader.new(StringIO.new(content)).read.to_s

  def gzip(content)
    gzip_content = StringIO.new
    gz = Zlib::GzipWriter.new(gzip_content, Zlib::BEST_COMPRESSION)
    gz.write(content)
    gz.close
    gzip_content.string
  end

  def convert_to(extension, content)
    svg_cache_filename = Jim::CacheManager.svg_image_filename(@sha256, extension)
    Jim::Utils.write_file_if_not_exist(svg_cache_filename, content)
  end
end
