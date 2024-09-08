# frozen_string_literal: true

require 'singleton'

class Jim::ChecksumManager
	include Singleton

	CHECKSUMS_JSON = "checksums.json"

	def initialize
		@checksums_json = Jim::System.local_cache_path(CHECKSUMS_JSON)
		@checksums = @checksums_json.exist? ? JSON.parse(@checksums_json.read) : {}
		ObjectSpace.define_finalizer(self, self.class.method(:finalize))
	end

	def sha256(filename)
		unless filename.exist?
			@checksums.delete(filename.to_s)
			return nil
		end

		stat = filename.stat
		mtime = (10 ** 9) * stat.mtime.tv_sec + stat.mtime.tv_nsec
		size = stat.size

		checksum_entry = @checksums[filename.to_s] || {}
		if checksum_entry.has_key?("sha256") && checksum_entry["mtime"] == mtime && checksum_entry["size"] == size
			return checksum_entry["sha256"]
		end

		sha256 = Digest::SHA256.file(filename).hexdigest
		@checksums[filename.to_s] = { "mtime" => mtime, "size" => size, "sha256" => sha256 }
		sha256
	end

	def self.sha256(filename) = instance.sha256(filename)

	def finalize = Jim::Utils.write_json_file(@checksums_json, @checksums.sort.to_h)

	def self.finalize(_object_id) = instance.finalize
end
