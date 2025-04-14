# frozen_string_literal: true

require_relative 'jim/version'

module S10nsMixin
  DEFAULT_S10NS = { jim_version: Jim::VERSION }.freeze

  S10_KEY        = Jim::Validator.all('Symbol', '.+')
  S10_VALUE      = Jim::Validator.any(true, false, Integer, Float, String)
  S10_HASH       = Jim::Validator.hash(S10_KEY, S10_VALUE, allow_nil_values: true)
  S10_KEY_ARRAY  = Jim::Validator.array(S10_KEY)
  S10_HASH_ARRAY = Jim::Validator.array(S10_HASH, allow_nils: true)

  def s10ns(*s10ns, **kw_s10ns)
    s10ns = checked(S10_HASH_ARRAY, s10ns, :s10ns)
    kw_s10ns = checked(S10_HASH, kw_s10ns, :kw_s10ns)

    @s10ns = Jim::Utils.deep_merge(*s10ns, kw_s10ns)
  end

  def rm_s10ns(*keys)
    keys = checked(S10_KEY_ARRAY, keys, :keys)

    @s10ns.delete_if! { |key| keys.include?(key) }
  end

  protect_setters(:s10ns, :rm_s10ns)

  def add_s10ns(*s10ns, **kw_s10ns) = s10ns(@s10ns, *s10ns, kw_s10ns)
  def add_s10n(key, value) = add_s10ns({ key => value })
  def rm_s10n(key) = rm_s10ns(key)
  def rm_all_s10ns = s10ns
end

module Jim::LiquidFilters
  def jim_s10ns(jim, *s10ns) = jim.s10ns(jim, *s10ns)
  def jim_add_s10ns(jim, *s10ns) = jim.add_s10ns(jim, *s10ns)
  def jim_add_s10n(jim, key, value) = jim.add_s10n(key, value)
  def jim_rm_s10n(jim, key) = jim.rm_s10n(key)
  def jim_rm_s10ns(jim, *keys) = jim.rm_s10ns(*keys)
  def jim_rm_all_s10ns(jim) = jim.rm_all_s10ns
end
