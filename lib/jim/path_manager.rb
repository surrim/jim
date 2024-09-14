# frozen_string_literal: true

module Jim::PathManager
	module_function

	CHECKSUMS_JSON = "checksums.json"
	IMAGE_METADATA_JSON_PATTERN = "metadata/%{sha256}.json"

	def checksums_json = Jim::System.local_cache_path(CHECKSUMS_JSON)
	def image_metadata_json_pattern(sha256) = Jim::System.cache_path(IMAGE_METADATA_JSON_PATTERN % { sha256: sha256 })
end
