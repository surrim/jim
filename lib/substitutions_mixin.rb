# frozen_string_literal: true

require_relative 'jim/version'

module SubstitutionsMixin
  DEFAULT_SUBSTITUTIONS = { jim_version: Jim::VERSION }.freeze

  SS_KEY        = Jim::Validator.all('Symbol', '.+')
  SS_VALUE      = Jim::Validator.any(true, false, Integer, Float, String)
  SS_HASH       = Jim::Validator.hash(SS_KEY, SS_VALUE, allow_nil_values: true)
  SS_KEY_ARRAY  = Jim::Validator.array(SS_KEY)
  SS_HASH_ARRAY = Jim::Validator.array(SS_HASH, allow_nils: true)

  def substitutions(*substitutions, **kw_substitutions)
    substitutions = checked(SS_HASH_ARRAY, substitutions, :substitutions)
    kw_substitutions = checked(SS_HASH, kw_substitutions, :kw_substitutions)

    @substitutions = Jim::Utils.deep_merge(*substitutions, kw_substitutions)
  end

  def rm_substitutions(*keys)
    keys = checked(SS_KEY_ARRAY, keys, :keys)

    @substitutions.delete_if! { |key| keys.include?(key) }
  end

  protect_setters(:substitutions, :rm_substitutions)

  def add_substitutions(*substitutions, **kw_substitutions) = substitutions(@substitutions, *substitutions, kw_substitutions) # rubocop:disable Layout/LineLength
  def add_substitution(key, value) = add_substitutions({ key => value })
  def rm_substitution(key) = rm_substitutions(key)
  def rm_all_substitutions = substitutions
end

module Jim::LiquidFilters
  def jim_substitutions(jim, *substitutions) = jim.substitutions(jim, *substitutions)
  def jim_add_substitutions(jim, *substitutions) = jim.add_substitutions(jim, *substitutions)
  def jim_add_substitution(jim, key, value) = jim.add_substitution(key, value)
  def jim_rm_substitution(jim, key) = jim.rm_substitution(key)
  def jim_rm_substitutions(jim, *keys) = jim.rm_substitutions(*keys)
  def jim_rm_all_substitutions(jim) = jim.rm_all_substitutions
end
