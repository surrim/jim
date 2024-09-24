# frozen_string_literal: true

require_relative "jim.version"

class Jim
  attr_reader :substitutions

  DEFAULT_SUBSTITUTIONS = { jim_version: Jim::VERSION }

  def substitutions(*substitutions)
    rm_substitutions
    {}.merge(*substitutions.compact).each { |key, value|
      add_substitution(key, value)
    }
    self
  end

  def add_substitution(key, value)
    if value.nil?
      @substitutions.delete(key.to_sym)
    else
      @substitutions[key.to_sym] = value
    end
    self
  end

  def rm_substitution(key) = add_substitution(key, nil)

  def rm_substitutions
    @substitutions = {}
    self
  end

  module LiquidFilters
    def jim_substitutions(jim, *substitutions) = jim.substitutions(jim, substitutions)
    def jim_add_substitution(jim, key, value) = jim.add_substitution(key, value)
    def jim_rm_substitution(jim, key) = jim.rm_substitution(key)
    def jim_rm_substitutions(jim) = jim.rm_substitutions
  end
end
