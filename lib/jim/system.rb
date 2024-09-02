module Jim::System
	module_function

	def info(text) = @logger.info("Jim:", text)
	def warn(text) = @logger.warn("Jim:", text)
	def config(key) = @site.config[key.to_s]
	def init(site, logger)
		@site = site
		@logger = logger
		if config(:jim_cache)
			info("using file://#{File.expand_path(config(:jim_cache))}")
		else
			warn("jim_cache not configured")
		end		
	end
end
