# frozen_string_literal: true

module Jim::System
	module_function

	def info(text) = @logger.info("Jim:", text) && nil

	def warn(text) = @logger.warn("Jim:", text) && nil

	def error(text) = @logger.error("Jim:", text) && nil

	def config = @site.config

	def path(*src) = Pathname.new(".").join(*src).expand_path(@site_root_dir ||= config["root_dir"])

	def source_path(*src) = Pathname.new(".").join(*src).expand_path(@site_source_dir ||= config["source"])

	def destination_path(*src) = Pathname.new(@site.in_dest_dir(*src))

	def local_cache_path(*src) = Pathname.new(@site.in_cache_dir("jimcache", *src))

	def cache_path(*src) = config[:jim_cache] ? path(config[:jim_cache], *src) : local_cache_path(*src)

	def init(site, logger)
		@site = site
		@logger = logger
		if config[:jim_cache]
			info("using file://#{File.expand_path(config[:jim_cache])}")
		else
			warn("jim_cache not configured")
		end
	end
end
