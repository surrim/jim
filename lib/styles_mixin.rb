# frozen_string_literal: true

module StylesMixin
  DEFAULT_STYLES = {}.freeze

  def assert_valid_property(property) = assert_all('String', '.+', property, :property)
  def assert_valid_values(values) = assert_all('Array', values, :values)

  def assert_valid_styles(styles)
    return if styles.nil?

    assert_all('Hash', styles, :styles)
    styles.each do |property, values|
      assert_valid_property(property)
      assert_valid_values(values)
    end
  end

  def styles(*styles, **kw_style)
    merged_styles = Jim::Utils.deep_merge(*styles, kw_style)
    assert_valid_styles(merged_styles)
    @styles = merged_styles
  end

  def style(property, *values)
    assert_valid_property(property)
    assert_valid_values(values)
    @styles = Jim::Utils.deep_merge(@styles, { property => values.join(' ') })
  end

  protect_setters(:styles, :style)

  def rm_style(property) = style(property)
  def rm_styles(*properties) = styles(properties.map { |property| [property, nil] }.to_h)
  def rm_all_styles = styles
end

module Jim::LiquidFilters
  def jim_styles(jim, *styles) = jim.styles(styles)
  def jim_style(jim, property, *values) = jim.style(property, values)
  def jim_rm_style(jim, property) = jim.rm_style(property)
  def jim_rm_styles(jim, *properties) = jim.rm_styles(*properties)
  def jim_rm_all_styles(jim) = jim.rm_all_styles
end
