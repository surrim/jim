# frozen_string_literal: true

require 'fcntl'
require 'mime-types'
require 'rmagick'

module Jim::Utils
  module_function

  LOSSLESS_MIME_TYPES = %w[image/bmp image/gif image/png image/svg+xml image/tiff image/vnd.microsoft.icon].freeze

  def dig_hash(hash, *path_keys)
    path_keys.each do |path_key|
      return nil unless hash.is_a?(Hash)

      found = hash.find { |key, _| key.to_s == path_key.to_s }
      return nil unless found

      hash = found.last
    end
    hash
  end

  def deep_stringify_keys(object)
    case object
    when Hash
      object.transform_keys { |key| key&.to_s }
            .transform_values { |value| deep_stringify_keys(value) }
    when Array
      object.map { |value| deep_stringify_keys(value) }
    else
      object
    end
  end

  def deep_dup(object, strip: true)
    case object
    when Hash
      object.transform_keys { |key| deep_dup(key) }
            .transform_values { |value| deep_dup(value) }
            .delete_if { |_key, value| strip && value.nil? }
            .then { |h| strip && h.empty? ? nil : h }
    when Array
      object.map { |value| deep_dup(value) }
    when String
      object.dup
    when NilClass, TrueClass, FalseClass, Numeric, Symbol, Regexp
      object
    else
      Jim::System.warn("Unknown type #{object.class} (#{object.inspect}) to duplicate")
      object.dup
    end
  end

  def deep_merge(*hashes, strip: true) = deep_dup(simple_deep_merge(*hashes), strip: strip)

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
    Jim::System.error(JSON::ParserError, "#{filename} does not contain valid JSON data")
  end

  def write_json_file(filename, content) = write_file(filename, JSON.pretty_generate(content))

  def mute_stderr
    saved_stderr_fd = IO.new($stderr.fcntl(Fcntl::F_DUPFD, 0))
    dev_null = File.open(File::NULL, 'w')
    begin
      $stderr.reopen(dev_null)
      $stderr.sync = true
      yield
    ensure
      $stderr.reopen(saved_stderr_fd)
      saved_stderr_fd.close
      dev_null.close
    end
  end

  def load_image(filename)
    image = nil
    mute_stderr do
      image = Magick::ImageList.new(filename.to_s, &:channel).auto_orient
      image.strip!
    end
    image
  end

  def color(color)
    return nil if color.nil?

    Magick::Pixel.from_color(color).to_color(Magick::NoCompliance, true, 8, true).downcase[1..]
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

  SORT_CLASS_PRECEDENCE = {
    NilClass => 0,
    TrueClass => 1,
    FalseClass => 2,
    Integer => 3,
    Float => 4,
    Rational => 5,
    Date => 6,
    Time => 7,
    String => 9,
    Symbol => 9
  }.freeze

  def simple_deep_merge(*hashes)
    return {} if hashes.empty?

    last_hash = hashes.pop
    return last_hash unless last_hash.is_a?(Hash)

    until hashes.empty?
      hash = hashes.pop
      break unless hash.is_a?(Hash)

      hash.each_key do |key|
        unless last_hash.key?(key)
          last_hash[key] = hash[key]
          next
        end
        next unless last_hash[key].is_a?(Hash)

        last_hash[key] = simple_deep_merge(hash[key], last_hash[key])
      end
    end
    last_hash.sort_by { |key, _value| [SORT_CLASS_PRECEDENCE[key.class] || -key.object_id, key] }.to_h
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
