# frozen_string_literal: true

module ImgAttrsMixin
  DEFAULT_IMG_ATTRS = {}.freeze

  IA_KEY        = Jim::Validator.all('String', '.+', '[a-z]*')
  IA_VALUE      = Jim::Validator.any(Integer, Float, String)
  IA_KEY_ARRAY  = Jim::Validator.array(IA_KEY)
  IA_HASH       = Jim::Validator.hash(IA_KEY, IA_VALUE, allow_nil_values: true)
  IA_HASH_ARRAY = Jim::Validator.array(IA_HASH, allow_nils: true)

  def img_attrs(*img_attrs, **kw_img_attrs)
    img_attrs = checked(IA_HASH_ARRAY, img_attrs, :img_attrs)
    kw_img_attrs = checked(IA_HASH, kw_img_attrs, :kw_img_attrs)

    @img_attrs = Jim::Utils.deep_merge(*img_attrs, kw_img_attrs)
  end

  def rm_img_attrs(*keys)
    keys = checked(IA_KEY_ARRAY, keys, :keys)

    @img_attrs.delete_if! { |key| keys.include?(key) }
  end

  protect_setters(:img_attrs, :rm_img_attrs)

  def merge_img_attrs(*img_attrs, **kw_img_attrs) = img_attrs(@img_attrs, *img_attrs, **kw_img_attrs)
  def img_attr(key, value) = img_attrs(@img_attrs, { key => value })
  def rm_img_attr(key) = rm_img_attrs(key)
  def rm_all_img_attrs = img_attrs
end

module Jim::LiquidFilters
  def jim_img_attrs(jim, *img_attrs) = jim.img_attrs(*img_attrs)
  def jim_merge_img_attrs(jim, *img_attrs) = jim.merge_img_attrs(*img_attrs)
  def jim_img_attr(jim, key, value) = jim.img_attr(key, value)
  def jim_rm_img_attr(jim, key) = jim.rm_img_attr(key)
  def jim_rm_img_attrs(jim, *keys) = jim.rm_img_attrs(*keys)
  def jim_rm_all_img_attrs(jim) = jim.rm_all_img_attrs
end
