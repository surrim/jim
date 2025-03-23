# frozen_string_literal: true

module WatermarkMixin
  DEFAULT_WATERMARK_SRC = nil
  DEFAULT_WATERMARK_SIZE = 0.01
  DEFAULT_WATERMARK_X = 0.5
  DEFAULT_WATERMARK_Y = 0.5
  DEFAULT_WATERMARK_OPACITY = 0.5

  Jim.setter :watermark_src, &->(watermark_src = DEFAULT_WATERMARK_SRC) do
    return @watermark_src = nil if watermark_src.nil?

    assert_all('String', '.+', watermark_src, :watermark_src)
    @watermark_src = watermark_src.to_s
  end

  Jim.setter :watermark_size, &->(watermark_size = DEFAULT_WATERMARK_SIZE) do
    assert_all('Numeric', '>0', '<=1', watermark_size, :watermark_size)
    @watermark_size = watermark_size.to_f
  end

  Jim.setter :watermark_x, &->(watermark_x = DEFAULT_WATERMARK_X) do
    assert_all('Numeric', '>=0', '<=1', watermark_x, :watermark_x)
    @watermark_x = watermark_x.to_f
  end

  Jim.setter :watermark_y, &->(watermark_y = DEFAULT_WATERMARK_Y) do
    assert_all('Numeric', '>=0', '<=1', watermark_y, :watermark_y)
    @watermark_y = watermark_y.to_f
  end

  Jim.setter :watermark_opacity, &->(watermark_opacity = DEFAULT_WATERMARK_OPACITY) do
    assert_all('Numeric', '>=0', '<=1', watermark_opacity, :watermark_opacity)
    @watermark_opacity = watermark_opacity.to_f
  end

  Jim.setter :watermark, &->(watermark_src, **options) do
    watermark_src(watermark_src)
    watermark_size(options[:watermark_size]) if options.key?(:watermark_size)
    watermark_x(options[:watermark_x]) if options.key?(:watermark_x)
    watermark_y(options[:watermark_y]) if options.key?(:watermark_y)
    watermark_opacity(options[:watermark_opacity]) if options.key?(:watermark_opacity)
  end

  def rm_watermark = watermark_src(nil)
end

module Jim::LiquidFilters
  def jim_watermark_src(jim, watermark_src) = jim.watermark_src(watermark_src)
  def jim_watermark_size(jim, watermark_size) = jim.watermark_size(watermark_size)
  def jim_watermark_x(jim, watermark_x) = jim.watermark_x(watermark_x)
  def jim_watermark_y(jim, watermark_y) = jim.watermark_y(watermark_y)
  def jim_watermark_opacity(jim, watermark_opacity) = jim.watermark_opacity(watermark_opacity)

  def jim_watermark(
    jim,
    watermark_src,
    watermark_size = DEFAULT_WATERMARK_SIZE,
    watermark_x = DEFAULT_WATERMARK_X,
    watermark_y = DEFAULT_WATERMARK_Y,
    watermark_opacity = DEFAULT_WATERMARK_OPACITY
  ) = jim.watermark(watermark_src, watermark_size:, watermark_x:, watermark_y:, watermark_opacity:)

  def jim_rm_watermark(jim) = jim.rm_watermark
end
