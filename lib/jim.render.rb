# frozen_string_literal: true

class Jim
  def render(render = true)
    attr = compute_source_attr

    destination_filename = nil
    generated_images = []
    if attr[:source_is_svg] && @svg_filename_pattern
      svg_source_image = SvgSourceImage.new(attr[:source_filename], attr[:source_sha256])
      if @svg_filename_pattern == "" # inline SVG/SVGZ
        return svg_source_image.convert_to_inline_svg.read if render
      else
        # copy SVG/SVGZ -> SVG/SVGZ
        attr.update(
          compute_resizing_attr(attr[:source_width], **attr.slice(:source_width, :source_height))
        )
        attr.update(compute_output_attr(attr[:source_extension]))
        destination_filename = Jim::Utils.replace_filename_pattern(
          @svg_filename_pattern,
          @substitutions,
          **attr.slice(
            :source_sha256, :source_extension, :source_dirname, :source_basename,
            :resizing_width, :resizing_height,
            :output_extension, :output_background, :output_is_lossless, :output_quality
          )
        )
        compress = destination_filename.extname.downcase == ".svgz"
        cache_filename = svg_source_image.convert(compress)
        Jim::System.add_external_file(cache_filename, destination_filename)
      end
    else
      attr.update(compute_resizing_attr(
                    @fallback_width || attr[:source_width],
                    **attr.slice(:source_width, :source_height))
      )
      attr.update(compute_watermark_attr(
                    **attr.slice(:source_width, :source_height, :resizing_width, :resizing_height))
      )
      attr.update(compute_output_attr(
                    @fallback_format || attr[:source_extension])
      )

      # no svg special cases
      resized_image = ResizedImage.new(**attr.slice(
        :source_filename, :source_sha256,
        :resizing_width, :resizing_height,
        :watermark_filename, :watermark_sha256, :watermark_width, :watermark_height,
        :watermark_x, :watermark_y, :watermark_opacity, :watermark_is_valid
      ))
      fallback_cache_filename = resized_image.write(**attr.slice(
        :output_background, :output_extension, :output_is_lossless, :output_quality
      ))
      destination_filename = Jim::Utils.replace_filename_pattern(
        @filename_pattern,
        @substitutions,
        **attr.slice(
          :source_sha256, :source_extension, :source_dirname, :source_basename,
          :resizing_width, :resizing_height,
          :output_extension, :output_background, :output_is_lossless, :output_quality
        )
      )
      Jim::System.add_external_file(fallback_cache_filename, destination_filename)

      resizing_and_watermark_attrs = @widths
                                       .map { |width| width || attr[:source_width] }
                                       .uniq
                                       .select { |width| width <= attr[:source_width] || attr[:source_is_svg] }
                                       .map do |width|
        resizing_and_watermark_attr = attr.slice(:source_width, :source_height)
        resizing_and_watermark_attr.update(**compute_resizing_attr(width, **resizing_and_watermark_attr.slice(
          :source_width, :source_height
        )))
        resizing_and_watermark_attr.update(**compute_watermark_attr(**resizing_and_watermark_attr.slice(
          :source_width, :source_height, :resizing_width, :resizing_height
        )))
      end
      output_attrs = @formats
                       .map { |format| format || attr[:source_extension] }
                       .uniq
                       .map do |format|
        compute_output_attr(format)
      end

      resizing_and_watermark_attrs.each do |resizing_and_watermark_attr|
        attr.update(resizing_and_watermark_attr)

        resized_image = ResizedImage.new(**attr.slice(
          :source_filename, :source_sha256,
          :resizing_width, :resizing_height,
          :watermark_filename, :watermark_sha256, :watermark_width, :watermark_height,
          :watermark_x, :watermark_y, :watermark_opacity, :watermark_is_valid
        ))

        output_attrs.each do |output_attr|
          attr.update(output_attr)

          generated_cache_filename = resized_image.write(**attr.slice(
            :output_background, :output_extension,
            :output_is_lossless, :output_quality
          ))
          generated_filename = Jim::Utils.replace_filename_pattern(
            @filename_pattern,
            @substitutions,
            **attr.slice(
              :source_sha256, :source_extension, :source_dirname, :source_basename,
              :resizing_width, :resizing_height,
              :output_extension, :output_background, :output_is_lossless, :output_quality
            )
          )
          generated_images.push({
                                  src: generated_filename&.relative_path_from(Jim::System.destination_path)&.to_s,
                                  mime_type: attr[:output_mime_type],
                                  width: attr[:resizing_width]
                                })
          Jim::System.add_external_file(generated_cache_filename, generated_filename)
        end
      end
    end

    output = {
      src: destination_filename&.relative_path_from(Jim::System.destination_path)&.to_s,
      alt: @alt,
      sha256: attr[:source_sha256],
      width: attr[:resizing_width],
      height: attr[:resizing_height],
      simplified_width: attr[:resizing_simplified_width],
      simplified_height: attr[:resizing_simplified_height],
      mime_type: attr[:output_mime_type],
      avg_color: attr[:source_avg_color],
      images: generated_images,
      img_sizes: @img_sizes,
      img_attrs: @img_attrs,
      styles: @styles
    }
    if render
      output = "{::nomarkdown}\n#{output}\n{:/nomarkdown}\n" if @nomarkdown
    end
    output
  end

  private

  RATIONALIZE_TOLERANCE = 0.005

  def compute_source_attr
    source_image = SourceImage.new(@src)
    {
      source_filename: source_image.filename,
      source_dirname: source_image.dirname,
      source_basename: source_image.basename,
      source_extension: source_image.extension,
      source_sha256: source_image.sha256,
      source_width: source_image.width,
      source_height: source_image.height,
      source_mime_type: source_image.mime_type,
      source_avg_color: source_image.avg_color,
      source_is_svg: source_image.is_svg?
    }
  end

  def compute_resizing_attr(width, source_width:, source_height:)
    ratio = (source_width.to_f / source_height).rationalize(RATIONALIZE_TOLERANCE)
    {
      resizing_width: width,
      resizing_height: (width.to_f / source_width * source_height).round,
      resizing_simplified_width: ratio.numerator,
      resizing_simplified_height: ratio.denominator
    }
  end

  def compute_watermark_attr(source_width:, source_height:, resizing_width:, resizing_height:)
    if @watermark_src
      watermark_source_image = Jim::SourceImage.new(@watermark_src)
      watermark_filename = watermark_source_image.filename
      watermark_sha256 = watermark_source_image.sha256
      wwsh = watermark_source_image.width * source_height
      whsw = watermark_source_image.height * source_width
      watermark_width = (resizing_width * Math.sqrt(@watermark_size * wwsh / whsw)).round
      watermark_height = (resizing_height * Math.sqrt(@watermark_size * whsw / wwsh)).round
      watermark_x = ((resizing_width - watermark_width) * @watermark_x).round
      watermark_y = ((resizing_height - watermark_height) * @watermark_y).round
      watermark_opacity = @watermark_opacity.round(3)
      watermark_is_valid = \
        watermark_source_image != nil \
          && watermark_width > 0 \
          && watermark_height > 0 \
          && watermark_opacity > 0
    end
    watermark_is_valid ? {
      watermark_src: @watermark_src,
      watermark_filename: watermark_filename,
      watermark_sha256: watermark_sha256,
      watermark_width: watermark_width,
      watermark_height: watermark_height,
      watermark_x: watermark_x,
      watermark_y: watermark_y,
      watermark_opacity: watermark_opacity,
      watermark_is_valid: watermark_is_valid
    } : { watermark_is_valid: false }
  end

  def compute_output_attr(format)
    output_mime_type = Jim::Utils.auto_convert_mime_type(format)
    format_setup = {}.merge(@format_setups[""] || {}, @format_setups[output_mime_type] || {})
    output_extension = format.include?("/") ? Jim::Utils.preferred_extension_for_mime_type(output_mime_type) : format
    output_background = Jim::Utils.color(format_setup["background"])
    output_is_lossless = Jim::Utils.is_lossless_mime_type?(output_mime_type)
    output_quality = format_setup["quality"]
    {
      output_mime_type: output_mime_type,
      output_extension: output_extension,
      output_background: output_background,
      output_is_lossless: output_is_lossless,
      output_quality: output_quality
    }
  end

  module LiquidFilters
    def jim_render(jim, render = true) = jim.render(render)
  end
end
