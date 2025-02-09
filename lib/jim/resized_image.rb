# frozen_string_literal: true

class Jim::ResizedImage
  # needs source_image, resizing, watermark
  def initialize(
    source_filename:, source_sha256:,
    resizing_width:, resizing_height:,
    watermark_filename: nil, watermark_sha256: nil, watermark_width: nil, watermark_height: nil,
    watermark_x: nil, watermark_y: nil, watermark_opacity: nil, watermark_is_valid: false
  )
    @source_filename = source_filename
    @source_sha256 = source_sha256
    @resizing_width = resizing_width
    @resizing_height = resizing_height
    @watermark_filename = watermark_filename
    @watermark_sha256 = watermark_sha256
    @watermark_width = watermark_width
    @watermark_height = watermark_height
    @watermark_x = watermark_x
    @watermark_y = watermark_y
    @watermark_opacity = watermark_opacity
    @watermark_is_valid = watermark_is_valid
  end

  def image
    return @image if @image

    @image = self.class.load_resized_image(
      source_filename: @source_filename, source_sha256: @source_sha256,
      resizing_width: @resizing_width, resizing_height: @resizing_height
    )
    if @watermark_is_valid
      watermark_image = self.class.load_resized_image(
        source_filename: @watermark_filename, source_sha256: @watermark_sha256,
        resizing_width: @watermark_width, resizing_height: @watermark_height
      )
      @image = @image.dissolve(watermark_image, @watermark_opacity, 1, @watermark_x, @watermark_y)
    end
    @image
  end

  def write(output_background: nil, output_extension:, output_is_lossless:, output_quality:)
    cache_filename = Jim::CacheManager.image_filename(
      source_sha256: @source_sha256,
      resizing_width: @resizing_width, resizing_height: @resizing_height,
      watermark_sha256: @watermark_sha256, watermark_width: @watermark_width, watermark_height: @watermark_height,
      watermark_x: @watermark_x, watermark_y: @watermark_y,
      watermark_opacity: @watermark_opacity, watermark_is_valid: @watermark_is_valid,
      output_background:, output_extension:, output_is_lossless:, output_quality:
    )
    Jim::Utils.write_file_if_not_exist(cache_filename) do |filename|
      source_src = @source_filename.relative_path_from(Jim::System.source_path)
      format = "#{output_extension}#{output_quality ? "/##{output_quality}" : nil}"
      Jim::System.info('Converting', "#{source_src} (#{format}, #{@resizing_width}x#{@resizing_height})")
      output_image = image
      if output_background
        image_list = Magick::ImageList.new
        image_list.new_image(@resizing_width, @resizing_height) do |options|
          options.background_color = output_background
        end
        image_list.push(output_image)
        output_image = image_list.flatten_images
      end
      output_image.write("#{output_extension}:#{filename}") do |info|
        info.quality = output_quality unless output_is_lossless
        info.channel
      end
    end
  end

  def self.load_resized_image(
    source_filename:, source_sha256:,
    resizing_width:, resizing_height:
  )
    if %w[.svg .svgz].include?(source_filename.extname.downcase)
      png_cache_filename = Jim::CacheManager.image_filename(
        source_sha256:,
        resizing_width:, resizing_height:,
        output_extension: 'png', output_is_lossless: true, output_quality: nil
      )
      Jim::Utils.write_file_if_not_exist(png_cache_filename) do |filename|
        system(
          'inkscape', source_filename.to_s,
          '-w', resizing_width.to_s, '-h', resizing_height.to_s,
          '-o', '-', '--export-type=png', '--export-png-color-mode=RGBA_16',
          out: filename.to_s, exception: true
        )
      end
      Jim::Utils.load_image(png_cache_filename)
    else
      Jim::Utils.load_image(source_filename).resize(resizing_width, resizing_height)
    end
  end
end
