# frozen_string_literal: true

module WatermarkMixin
  DEFAULT_WATERMARK_SRC = nil
  DEFAULT_WATERMARK_SIZE = 0.01
  DEFAULT_WATERMARK_X = 0.5
  DEFAULT_WATERMARK_Y = 0.5
  DEFAULT_WATERMARK_OPACITY = 0.5

  def watermark_src(watermark_src = DEFAULT_WATERMARK_SRC)
    return @watermark_src = nil if watermark_src.nil?

    assert_all('String', '.+', watermark_src, :watermark_src)
    @watermark_src = watermark_src.to_s
  end

  def watermark_size(watermark_size = DEFAULT_WATERMARK_SIZE)
    assert_all('Numeric', '>0', '<=1', watermark_size, :watermark_size)
    @watermark_size = watermark_size.to_f
  end

  def watermark_x(watermark_x = DEFAULT_WATERMARK_X)
    assert_all('Numeric', '>=0', '<=1', watermark_x, :watermark_x)
    @watermark_x = watermark_x.to_f
  end

  def watermark_y(watermark_y = DEFAULT_WATERMARK_Y)
    assert_all('Numeric', '>=0', '<=1', watermark_y, :watermark_y)
    @watermark_y = watermark_y.to_f
  end

  def watermark_opacity(watermark_opacity = DEFAULT_WATERMARK_OPACITY)
    assert_all('Numeric', '>=0', '<=1', watermark_opacity, :watermark_opacity)
    @watermark_opacity = watermark_opacity.to_f
  end

  protect_setters(:watermark_src, :watermark_size, :watermark_x, :watermark_y, :watermark_opacity)

  def watermark(src: UNDEFINED, size: UNDEFINED, x: UNDEFINED, y: UNDEFINED, opacity: UNDEFINED) # rubocop:disable Naming/MethodParameterName
    watermark_src(src) if src != UNDEFINED
    watermark_size(size) if size != UNDEFINED
    watermark_x(x) if x != UNDEFINED
    watermark_y(y) if y != UNDEFINED
    watermark_opacity(opacity) if opacity != UNDEFINED
    self
  end

  def rm_watermark = watermark_src(nil)
end

module Jim::LiquidFilters
  def jim_watermark_src(jim, watermark_src) = jim.watermark_src(watermark_src)
  def jim_watermark_size(jim, watermark_size) = jim.watermark_size(watermark_size)
  def jim_watermark_x(jim, watermark_x) = jim.watermark_x(watermark_x)
  def jim_watermark_y(jim, watermark_y) = jim.watermark_y(watermark_y)
  def jim_watermark_opacity(jim, watermark_opacity) = jim.watermark_opacity(watermark_opacity)

  def jim_watermark(jim, src = UNDEFINED, size = UNDEFINED, x = UNDEFINED, y = UNDEFINED, opacity = UNDEFINED) # rubocop:disable Naming/MethodParameterName
    jim.watermark(src:, size:, x:, y:, opacity:)
  end

  def jim_rm_watermark(jim) = jim.rm_watermark
end
