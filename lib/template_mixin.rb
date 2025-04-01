# frozen_string_literal: true

module TemplateMixin
  DEFAULT_TEMPLATE = nil # see Jim::System.DEFAULT_TEMPLATE

  def template(template)
    return @template = nil if template.nil?

    assert_all('String', '.+', template, :template)
    @template = template
  end

  protect_setters(:template)

  def reset_template = template(nil)
end

module Jim::LiquidFilters
  def jim_template(jim, template) = jim.template(template)
  def jim_reset_template(jim) = jim.reset_template
end
