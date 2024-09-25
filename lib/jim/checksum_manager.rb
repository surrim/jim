# frozen_string_literal: true

require "singleton"

class Jim::ChecksumManager
  include Singleton

  def initialize
    @checksums_json = Jim::CacheManager.checksums_json
    @checksums = @checksums_json.exist? ? Jim::Utils.read_json_file(@checksums_json) : {}
    ObjectSpace.define_finalizer(self, self.class.method(:finalize))
  end

  def sha256(filename)
    unless filename.exist?
      @checksums.delete(filename.to_s.to_sym)
      Jim::System.error("FilesystemError: #{filename} not found")
    end

    stat = filename.stat
    mtime = (10**9) * stat.mtime.tv_sec + stat.mtime.tv_nsec
    size = stat.size

    checksum_entry = @checksums[filename.to_s.to_sym] || {}
    if checksum_entry.key?(:sha256) && checksum_entry[:mtime] == mtime && checksum_entry[:size] == size
      return checksum_entry[:sha256]
    end

    sha256 = Digest::SHA256.file(filename.to_s).hexdigest
    @checksums[filename.to_s.to_sym] = { mtime:, size:, sha256: }
    sha256
  end

  def self.sha256(filename) = instance.sha256(filename)

  def finalize
    if @checksums.empty?
      @checksums_json.delete if @checksums_json.exist?
    else
      Jim::Utils.write_json_file(@checksums_json, @checksums.sort.to_h)
    end
  end

  def self.finalize(_object_id) = instance.finalize
end
