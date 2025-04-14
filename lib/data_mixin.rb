# frozen_string_literal: true

module DataMixin
  D_PATH_ITEM       = Jim::Validator.any(String, Symbol)
  D_PATH_ITEMS      = Jim::Validator.array(D_PATH_ITEM, allow_nils: true)
  D_STRINGIFY_KEYS  = Jim::Validator.all('Bool', allow_nil: true)

  def data(*path, stringify_keys: true)
    path = checked(D_PATH_ITEMS, path, :path)
    stringify_keys = checked(D_STRINGIFY_KEYS, stringify_keys, :stringify_keys)

    hash = Jim::Utils.dig_hash(to_h, *path)
    stringify_keys ? Jim::Utils.deep_stringify_keys(hash) : hash
  rescue StandardError => e
    Jim::System.warn("Error in method `#{__method__}`:\n#{e.message}")
    nil
  end
end

module Jim::LiquidFilters
  def jim_data(jim, *path) = jim.data(*path)
end
