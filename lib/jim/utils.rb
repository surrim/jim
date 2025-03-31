# frozen_string_literal: true

require 'mime-types'
require 'rmagick'

module Jim::Utils
  module_function

  LOSSLESS_MIME_TYPES = %w[image/bmp image/gif image/png image/svg+xml image/tiff image/vnd.microsoft.icon].freeze

  def deep_stringify_keys(object)
    case object
    when Hash
      object.transform_keys(&:to_s)
            .transform_values { |value| deep_stringify_keys(value) }
            .delete_if { |_key, value| value.nil? }
            .then { |h| h.empty? ? nil : h }
    when Array
      object.map { |value| deep_stringify_keys(value) }
    when Symbol
      object.to_s
    when NilClass, TrueClass, FalseClass, Numeric, String, Regexp
      object
    else
      Jim::System.warn("Unknown type #{object.class} (#{object.inspect}) to stringify")
      object
    end.freeze
  end

  def deep_merge(*hashes) = deep_stringify_keys(simple_deep_merge(*hashes))

  def write_file(filename, content = '')
    prepare_folder(filename)
    tmp_filename = tmp_filename(filename)
    block_given? ? yield(tmp_filename) : tmp_filename.write(content)
    FileUtils.mv(tmp_filename, filename)
    filename
  end

  def write_file_if_not_exist(filename, content = '', &block)
    if filename.exist?
      FileUtils.touch(filename)
    else
      block_given? ? write_file(filename, content, &block) : write_file(filename, content)
    end
    filename
  end

  def read_json_file(filename)
    JSON.parse(filename.read, { symbolize_names: true })
  rescue JSON::ParserError
    Jim::System.error("JSON::ParserError: #{filename} does not contain valid JSON data")
  end

  def write_json_file(filename, content) = write_file(filename, JSON.pretty_generate(content))

  def load_image(filename)
    image = Magick::ImageList.new(filename.to_s, &:channel).auto_orient
    image.strip!
    image
  end

  def color(color)
    return nil if color.nil?

    Magick::Pixel.from_color(color).to_color(Magick::AllCompliance, true, 8, true).downcase[1..]
  end

  def mime_type(filename)
    return nil if filename.nil?

    types = MIME::Types.type_for(filename.to_s)
    if types.empty?
      Jim::System.warn("No MIME type available for #{filename}")
      return nil
    end
    types.first.content_type
  end

  def lossless_mime_type?(mime_type) = LOSSLESS_MIME_TYPES.include?(mime_type)

  def preferred_extension_for_mime_type(mime_type) = MIME::Types[mime_type]&.first&.preferred_extension

  def auto_convert_mime_type(format)
    return nil if format.to_s.empty?
    return format if format.include?('/')

    mime_type(".#{format}")
  end

  # TODO: used for Jim::Validator, refractoring needed for other functions
  def auto_convert_mime_type2(format)
    return format if format.include?('/')

    types = MIME::Types.type_for(".#{format}")
    return nil if types.empty?

    types.first.content_type
  end

  def replace_filename_pattern(
    filename_pattern, user_substitutions,
    source_blake3:, source_extension:, source_dirname:, source_basename:,
    resizing_width:, resizing_height:,
    output_extension:, output_background:, output_is_lossless:, output_quality:
  )
    substitutions = {
      blake3: source_blake3,
      dirname: clean_dirname(source_dirname),
      basename: clean_basename(source_basename),
      original_dirname: source_dirname,
      original_basename: source_basename,
      original_extension: source_extension,
      width: resizing_width,
      height: resizing_height,
      extension: output_extension,
      background: output_background,
      quality: output_is_lossless ? nil : output_quality
    }
    Jim::System.destination_path(Jim::Sprintf2.deep_substitute(filename_pattern, **user_substitutions, **substitutions))
  end

  private_class_method

  def simple_deep_merge(*hashes)
    return {} if hashes.empty?

    last_hash = hashes.pop.dup
    return last_hash unless last_hash.is_a?(Hash)

    last_hash.transform_keys!(&:to_s)
    until hashes.empty?
      hash = hashes.pop
      break unless hash.is_a?(Hash)

      hash.each_key do |key|
        unless last_hash.key?(key.to_s)
          last_hash[key.to_s] = hash[key]
          next
        end
        next unless last_hash[key.to_s].is_a?(Hash)

        last_hash[key.to_s] = deep_merge(hash[key], last_hash[key.to_s])
      end
    end
    last_hash.to_a.reverse.to_h
  end

  def tmp_filename(filename) = Pathname.new(filename.dirname + ".#{filename.basename}.tmp")

  def prepare_folder(filename) = FileUtils.mkdir_p(filename.dirname)

  def clean_dirname(dirname) = Pathname.new('.').join(*Pathname.new(dirname).each_filename.map do |basename|
    clean_basename(basename)
  end).to_s

  def clean_basename(basename)
    if %w[_ _. _..].include?(basename)
      Jim::System.warn("SubstitutionError: Preserving leading underscore from \"#{basename}\"")
      return basename
    end
    basename.chr == '_' ? basename[1..].to_s : basename
  end
end
