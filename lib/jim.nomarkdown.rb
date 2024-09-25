# frozen_string_literal: true

class Jim
  attr_reader :nomarkdown

  DEFAULT_NOMARKDOWN = false

  def nomarkdown(nomarkdown = true)
    @nomarkdown = nomarkdown ? true : false
    self
  end

  module LiquidFilters
    def jim_nomarkdown(jim, nomarkdown = true) = jim.nomarkdown(nomarkdown)
  end
end
