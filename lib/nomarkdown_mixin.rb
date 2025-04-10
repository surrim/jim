# frozen_string_literal: true

module NomarkdownMixin
  DEFAULT_NOMARKDOWN = false

  def nomarkdown(nomarkdown = true) # rubocop:disable Style/OptionalBooleanParameter
    @nomarkdown = assert_all('Bool', nomarkdown, :nomarkdown)
  end

  protect_setters(:nomarkdown)
end

module Jim::LiquidFilters
  def jim_nomarkdown(jim, nomarkdown = true) = jim.nomarkdown(nomarkdown) # rubocop:disable Style/OptionalBooleanParameter
end
