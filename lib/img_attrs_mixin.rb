# frozen_string_literal: true

module ImgAttrsMixin
  DEFAULT_IMG_ATTRS = {}.freeze

  def assert_valid_key(key) = assert_all('String', '.+', '[a-z]*', key, :key)
  def assert_valid_value(value) = assert_all('Primitive', value, :value)

  def assert_valid_img_attrs(img_attrs)
    return if img_attrs.nil?

    assert_all('Hash', img_attrs, :img_attrs)
    img_attrs.each do |key, value|
      assert_valid_key(key)
      assert_valid_value(value)
    end
  end

  def img_attrs(*img_attrs, **kw_img_attrs)
    merged_img_attrs = Jim::Utils.deep_merge(*img_attrs, kw_img_attrs)
    assert_valid_img_attrs(merged_img_attrs)
    @img_attrs = merged_img_attrs
  end

  def img_attr(key, value)
    assert_valid_key(key)
    assert_valid_value(value)
    @img_attrs = Jim::Utils.deep_merge(@img_attrs, { key => value })
  end

  protect_setters(:img_attrs, :img_attr)

  def merge_img_attrs(*img_attrs, **kw_img_attrs) = img_attrs(@img_attrs, *img_attrs, **kw_img_attrs)
  def rm_img_attr(key) = img_attr(key, nil)
  def rm_img_attrs(*keys) = img_attrs(keys.map { |key| [key, nil] }.to_h)
  def rm_all_img_attrs = img_attrs
end

module Jim::LiquidFilters
  def jim_img_attrs(jim, *img_attrs) = jim.img_attrs(*img_attrs)
  def jim_img_attr(jim, key, value) = jim.img_attr(key, value)
  def jim_merge_img_attrs(jim, *img_attrs) = jim.merge_img_attrs(*img_attrs)
  def jim_rm_img_attr(jim, key) = jim.rm_img_attr(key)
  def jim_rm_img_attrs(jim, *keys) = jim.rm_img_attrs(*keys)
  def jim_rm_all_img_attrs(jim) = jim.rm_all_img_attrs
end
