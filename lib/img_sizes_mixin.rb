# frozen_string_literal: true

module ImgSizesMixin
  DEFAULT_IMG_SIZES = {}.freeze
  DEFAULT_DEFAULT_IMG_SIZE = nil

  def assert_valid_media_condition(media_condition) = assert_all('String', '.+', media_condition, :media_condition)

  def assert_valid_img_size(img_size)
    return if img_size.nil?

    assert_all('String', '.+', img_size, :img_size)
  end

  def assert_valid_img_sizes(img_sizes)
    return if img_sizes.nil?

    assert_all('Hash', img_sizes, :img_sizes)
    img_sizes.each do |media_condition, img_size|
      assert_valid_media_condition(media_condition)
      assert_valid_img_size(img_size)
    end
  end

  def img_sizes(*img_sizes, **kw_img_sizes)
    img_sizes = img_sizes.flatten
    merged_img_sizes = Jim::Utils.deep_merge(*img_sizes, kw_img_sizes)
    assert_valid_img_sizes(merged_img_sizes)
    @img_sizes = merged_img_sizes
  end

  def img_size(media_condition, img_size)
    assert_valid_media_condition(media_condition)
    assert_valid_img_size(img_size)
    @img_sizes[media_condition] = img_size
  end

  def default_img_size(default_img_size)
    assert_valid_img_size(default_img_size)
    @default_img_size = default_img_size
  end

  protect_setters(:img_sizes, :img_size, :default_img_size)

  def rm_img_size(media_condition) = img_size(media_condition, nil)

  def rm_img_sizes(*media_conditions)
    img_sizes(media_conditions.map { |media_condition| [media_condition, nil] }.to_h)
  end

  def rm_all_img_sizes = img_sizes
  def rm_default_img_size = default_img_size(nil)
end

module Jim::LiquidFilters
  def jim_img_sizes(jim, *img_sizes) = jim.img_sizes(*img_sizes)
  def jim_img_size(jim, media_condition, img_size) = jim.img_size(media_condition, img_size)
  def jim_default_img_size(jim, default_img_size) = jim.default_img_size(default_img_size)
  def jim_rm_img_size(jim, media_condition) = jim.rm_img_size(media_condition)
  def jim_rm_img_sizes(jim, *media_conditions) = jim.rm_img_sizes(*media_conditions)
  def jim_rm_all_img_sizes(jim) = jim.rm_all_img_sizes
  def jim_rm_default_img_size(jim) = jim.rm_default_img_size
end
