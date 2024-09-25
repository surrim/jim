# frozen_string_literal: true

class Jim
  attr_reader :watermark_src, :watermark_size, :watermark_x, :watermark_y, :watermark_opacity

  DEFAULT_WATERMARK_SRC = nil
  DEFAULT_WATERMARK_SIZE = 0.01
  DEFAULT_WATERMARK_X = 0.5
  DEFAULT_WATERMARK_Y = 0.5
  DEFAULT_WATERMARK_OPACITY = 0.5

  def watermark(watermark_src, watermark_size = nil, watermark_x = nil, watermark_y = nil, watermark_opacity = nil)
    watermark_src(watermark_src)
    watermark_size(watermark_size)
    watermark_x(watermark_x)
    watermark_y(watermark_y)
    watermark_opacity(watermark_opacity)
  end

  def watermark_src(watermark_src)
    @watermark_src = watermark_src&.to_s
    self
  end

  def watermark_size(watermark_size)
    @watermark_size = watermark_size.nil? ? DEFAULT_WATERMARK_SIZE : watermark_size.to_f \
      if Validator.check_nil_or_greater_than_zero(watermark_size, :watermark_size) \
      && Validator.check_nil_or_between_0_and_1(watermark_size, :watermark_size)
    self
  end

  def watermark_x(watermark_x)
    @watermark_x = watermark_x.nil? ? DEFAULT_WATERMARK_X : watermark_x.to_f \
      if Validator.check_nil_or_between_0_and_1(watermark_x, :watermark_x)
    self
  end

  def watermark_y(watermark_y)
    @watermark_y = watermark_y.nil? ? DEFAULT_WATERMARK_Y : watermark_y.to_f \
      if Validator.check_nil_or_between_0_and_1(watermark_y, :watermark_y)
    self
  end

  def watermark_opacity(watermark_opacity)
    @watermark_opacity = watermark_opacity.nil? ? DEFAULT_WATERMARK_OPACITY : watermark_opacity.to_f \
      if Validator.check_nil_or_greater_than_zero(watermark_opacity, :watermark_opacity) \
      && Validator.check_nil_or_between_0_and_1(watermark_opacity, :watermark_opacity)
    self
  end

  def rm_watermark = watermark_src(nil)

  module LiquidFilters
    def jim_watermark(jim, watermark_src, watermark_size = nil, watermark_x = nil, watermark_y = nil, watermark_opacity = nil) = jim.watermark(watermark_src, watermark_size, watermark_x, watermark_y, watermark_opacity)
    def jim_watermark_src(jim, watermark_src) = jim.watermark_src(watermark_src)
    def jim_watermark_size(jim, watermark_size) = jim.watermark_size(watermark_size)
    def jim_watermark_x(jim, watermark_x) = jim.watermark_x(watermark_x)
    def jim_watermark_y(jim, watermark_y) = jim.watermark_y(watermark_y)
    def jim_watermark_opacity(jim, watermark_opacity) = jim.watermark_opacity(watermark_opacity)
    def jim_rm_watermark(jim) = jim.rm_watermark
  end
end
