# frozen_string_literal: true

class Jim
  DEFAULT_IMG_SIZES = {}.freeze
  DEFAULT_DEFAULT_IMG_SIZE = nil

  def img_sizes(*img_sizes)
    rm_img_sizes
    {}.merge(*img_sizes.flatten.compact).each do |media_condition, size|
      add_img_size(media_condition, size)
    end
    self
  end

  def add_img_size(media_condition, img_size)
    if media_condition.to_s == ''
      @default_img_size = img_size&.to_s
    elsif img_size.nil?
      @img_sizes.delete(media_condition.to_s)
    else
      @img_sizes[media_condition.to_s] = img_size.to_s
    end
    self
  end

  def rm_img_size(media_condition) = add_img_size(media_condition, nil)

  def rm_img_sizes
    @img_sizes = {}
    self
  end

  def default_img_size(default_img_size) = add_img_size(nil, default_img_size)

  def rm_default_img_size = default_img_size(nil)

  module LiquidFilters
    def jim_img_sizes(jim, *img_sizes) = jim.img_sizes(img_sizes)
    def jim_add_img_size(jim, media_condition, img_size) = jim.add_img_size(media_condition, img_size)
    def jim_rm_img_size(jim, media_condition) = jim.rm_img_size(media_condition)
    def jim_rm_img_sizes(jim) = jim.rm_img_sizes
    def jim_default_img_size(jim, default_img_size) = jim.default_img_size(default_img_size)
    def jim_rm_default_img_size(jim) = jim.rm_default_img_size
  end
end
