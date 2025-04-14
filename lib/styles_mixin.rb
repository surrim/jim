# frozen_string_literal: true

module StylesMixin
  DEFAULT_STYLES = {}.freeze

  S_KEY        = Jim::Validator.all('String', '.+')
  S_VALUE      = Jim::Validator.all('String', '.+', allow_nil: true)
  S_HASH       = Jim::Validator.hash(S_KEY, S_VALUE, allow_nil_values: true)
  S_KEY_ARRAY  = Jim::Validator.array(S_KEY)
  S_HASH_ARRAY = Jim::Validator.array(S_HASH, allow_nils: true)

  def styles(*styles, **kw_style)
    styles = checked(S_HASH_ARRAY, styles, :styles)
    kw_style = checked(S_HASH, kw_style, :kw_style)

    @styles = Jim::Utils.deep_merge(*styles, kw_style)
  end

  def rm_styles(*properties)
    properties = checked(S_KEY_ARRAY, properties, :properties)

    @styles.delete_if! { |property| properties.include?(property) }
  end

  protect_setters(:styles, :rm_styles)

  def style(property, value) = styles(@styles, { property => value })
  def rm_style(property) = style(property, nil)
  def rm_all_styles = styles
end

module Jim::LiquidFilters
  def jim_styles(jim, *styles) = jim.styles(styles)
  def jim_style(jim, property, value) = jim.style(property, value)
  def jim_rm_style(jim, property) = jim.rm_style(property)
  def jim_rm_styles(jim, *properties) = jim.rm_styles(*properties)
  def jim_rm_all_styles(jim) = jim.rm_all_styles
end
