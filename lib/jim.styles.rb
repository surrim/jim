# frozen_string_literal: true

class Jim
  attr_reader :styles

  DEFAULT_STYLES = {}.freeze

  def styles(*styles)
    rm_styles
    {}.merge(*styles.flatten.compact).each do |property, values|
      add_style(property, values)
    end
    self
  end

  def add_style(property, *values)
    values = values.flatten.compact
    if values.empty?
      @styles.delete(property.to_s)
    else
      @styles[property.to_s] = values.join(" ")
    end
    self
  end

  def rm_style(property) = add_style(property)

  def rm_styles
    @styles = {}
    self
  end

  module LiquidFilters
    def jim_styles(jim, *styles) = jim.styles(styles)
    def jim_add_style(jim, property, *values) = jim.add_style(property, values)
    def jim_rm_style(jim, property) = jim.rm_style(property)
    def jim_rm_styles(jim) = jim.rm_styles
  end
end
