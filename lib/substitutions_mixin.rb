# frozen_string_literal: true

require_relative 'jim/version'

module SubstitutionsMixin
  DEFAULT_SUBSTITUTIONS = { jim_version: Jim::VERSION }.freeze

  def substitutions(*substitutions, **kw_substitutions)
    substitutions = assert_all('Hash', '{String,_}', '{_,Primitive}', substitutions, :substitutions)
    kw_substitutions = assert_all('Hash', '{String,_}', '{_,Primitive}', kw_substitutions, :kw_substitutions)
    @substitutions = Jim::Utils.deep_merge(*substitutions, kw_substitutions)
  end

  protect_setters(:substitutions, :rm_substitutions)

  def add_substitutions(*substitutions, **kw_substitutions) = substitutions(@substitutions, *substitutions, kw_substitutions) # rubocop:disable Layout/LineLength
  def add_substitution(key, value) = substitutions(@substitutions, { key => value })
  def rm_substitutions(*keys) = add_substitutions(keys.map { |key| [key, nil] }.to_h)
  def rm_substitution(key) = rm_substitutions(key)
  def rm_all_substitutions = substitutions
end

module Jim::LiquidFilters
  def jim_substitutions(jim, *substitutions) = jim.substitutions(jim, *substitutions)
  def jim_add_substitutions(jim, *substitutions) = jim.add_substitutions(jim, *substitutions)
  def jim_add_substitution(jim, key, value) = jim.add_substitution(key, value)
  def jim_rm_substitutions(jim, *keys) = jim.rm_substitutions(*keys)
  def jim_rm_substitution(jim, key) = jim.rm_substitution(key)
  def jim_rm_all_substitutions(jim) = jim.rm_all_substitutions
end
