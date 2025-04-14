# frozen_string_literal: true

module WidthsMixin
  DEFAULT_WIDTHS = [].freeze

  W_SORTER = ->(x, y) { (x || Float::INFINITY) <=> (y || Float::INFINITY) }

  W_VALUE       = Jim::Validator.all('Integer', '>0')
  W_VALUE_ARRAY = Jim::Validator.array(W_VALUE, flatten: true, allow_nils: true, uniq: true, sort: W_SORTER)

  def widths(*widths)
    @widths = checked(W_VALUE_ARRAY, widths, :widths)
  end

  def rm_widths(*widths)
    widths = checked(W_VALUE_ARRAY, widths, :widths)

    @widths.delete_if { |width| widths.include?(width) }
  end

  protect_setters(:widths, :rm_widths)

  def add_widths(*widths) = widths(@widths, *widths)
  def add_width(width) = add_widths(width)
  def rm_width(width) = rm_widths(width)
  def rm_all_widths = widths
end

module Jim::LiquidFilters
  def jim_widths(jim, *widths) = jim.widths(widths)
  def jim_rm_widths(jim, *widths) = jim.rm_widths(*widths)
  def jim_add_widths(jim, *widths) = jim.add_widths(*widths)
  def jim_add_width(jim, width) = jim.add_width(width)
  def jim_rm_width(jim, width) = jim.rm_width(width)
  def jim_rm_all_widths(jim) = jim.rm_all_widths
end
