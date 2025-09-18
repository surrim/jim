# frozen_string_literal: true

module ImgSizesMixin
  DEFAULT_IMG_SIZES = [].freeze

  IS_KEY         = Jim::Validator.all('String', '.+', allow_nil: true)
  IS_VALUE       = Jim::Validator.all('String', '.+')
  IS_TUPLE       = Jim::Validator.tuple(IS_KEY, IS_VALUE)
  IS_TUPLE_ARRAY = Jim::Validator.array(IS_TUPLE)
  IS_KEY_ARRAY   = Jim::Validator.array(IS_KEY, allow_nils: true)

  def img_sizes(img_sizes)
    @img_sizes = checked(IS_TUPLE_ARRAY, img_sizes, :img_sizes)
  end

  def rm_img_sizes(*media_conditions)
    media_conditions = checked(IS_KEY_ARRAY, media_conditions, :media_conditions)

    @img_sizes.delete_if { |img_size| media_conditions.include?(img_size.first) }
  end

  protect_setters(:img_sizes, :rm_img_sizes)

  def append_img_size(media_condition, img_size)
    rm_img_size(media_condition)
    img_sizes(@img_sizes.append([media_condition, img_size]))
  end

  def prepend_img_size(media_condition, img_size)
    rm_img_size(media_condition)
    img_sizes([[media_condition, img_size]].append(*@img_sizes))
  end

  def rm_img_size(media_condition) = rm_img_sizes(media_condition)
  def rm_all_img_sizes = img_sizes
end

module Jim::LiquidFilters
  def jim_img_sizes(jim, *img_sizes) = jim.img_sizes(*img_sizes)
  def jim_rm_img_sizes(jim, *media_conditions) = jim.rm_img_sizes(*media_conditions)
  def jim_append_img_size(jim, media_condition, img_size) = jim.append_img_size(media_condition, img_size)
  def jim_prepend_img_size(jim, media_condition, img_size) = jim.prepend_img_size(media_condition, img_size)
  def jim_rm_img_size(jim, media_condition) = jim.rm_img_size(media_condition)
  def jim_rm_all_img_sizes(jim) = jim.rm_all_img_sizes
end
