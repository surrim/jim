# frozen_string_literal: true

module ImgSizesMixin
  DEFAULT_IMG_SIZES = {}.freeze

  IS_KEY        = Jim::Validator.all('String', '.+')
  IS_VALUE      = Jim::Validator.all('String', '.+', allow_nil: true)
  IS_HASH       = Jim::Validator.hash(IS_KEY, IS_VALUE, allow_nil_key: true, allow_nil_values: true)
  IS_HASH_ARRAY = Jim::Validator.array(IS_HASH, allow_nils: true)
  IS_KEY_ARRAY  = Jim::Validator.array(IS_KEY, allow_nils: true)

  def img_sizes(*img_sizes, **kw_img_sizes)
    img_sizes = checked(IS_HASH_ARRAY, img_sizes, :img_sizes)
    kw_img_sizes = checked(IS_HASH, kw_img_sizes, :kw_img_sizes)

    @img_sizes = Jim::Utils.deep_merge(*img_sizes, kw_img_sizes)
  end

  def rm_img_sizes(*media_conditions)
    media_conditions = checked(IS_KEY_ARRAY, media_conditions, :media_conditions)

    @img_sizes.delete_if! { |media_condition| media_conditions.include?(media_condition) }
  end

  protect_setters(:img_sizes, :rm_img_sizes)

  def img_size(media_condition, img_size) = img_sizes(@img_sizes, { media_condition => img_size })
  def rm_img_size(media_condition) = img_size(media_condition, nil)
  def rm_all_img_sizes = img_sizes
end

module Jim::LiquidFilters
  def jim_img_sizes(jim, *img_sizes) = jim.img_sizes(*img_sizes)
  def jim_img_size(jim, media_condition, img_size) = jim.img_size(media_condition, img_size)
  def jim_rm_img_size(jim, media_condition) = jim.rm_img_size(media_condition)
  def jim_rm_img_sizes(jim, *media_conditions) = jim.rm_img_sizes(*media_conditions)
  def jim_rm_all_img_sizes(jim) = jim.rm_all_img_sizes
end
