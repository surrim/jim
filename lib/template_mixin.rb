# frozen_string_literal: true

module TemplateMixin
  DEFAULT_TEMPLATE = nil # see Jim::System.DEFAULT_TEMPLATE

  T_TEMPLATE = Jim::Validator.all('String', '.+', allow_nil: true)

  def template(template)
    @template = checked(T_TEMPLATE, template, :template)
  end

  protect_setters(:template)

  def reset_template = template(DEFAULT_TEMPLATE)
end

module Jim::LiquidFilters
  def jim_template(jim, template) = jim.template(template)
  def jim_reset_template(jim) = jim.reset_template
end
