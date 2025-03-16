# frozen_string_literal: true

module TemplateMixin
  DEFAULT_TEMPLATE = nil

  def template(template)
    @template = template&.to_s
    self
  end

  def reset_template = template(nil)
end

module Jim::LiquidFilters
  def jim_template(jim, template) = jim.template(template)
  def jim_reset_template(jim) = jim.reset_template
end
