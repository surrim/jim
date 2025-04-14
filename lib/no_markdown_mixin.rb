# frozen_string_literal: true

module NoMarkdownMixin
  DEFAULT_NO_MARKDOWN = false

  NM_NO_MARKDOWN = Jim::Validator.all('Bool')

  def no_markdown(no_markdown = true) # rubocop:disable Style/OptionalBooleanParameter
    @no_markdown = checked(NM_NO_MARKDOWN, no_markdown, :no_markdown)
  end

  protect_setters(:no_markdown)
end

module Jim::LiquidFilters
  def jim_no_markdown(jim, no_markdown = true) = jim.no_markdown(no_markdown) # rubocop:disable Style/OptionalBooleanParameter
end
