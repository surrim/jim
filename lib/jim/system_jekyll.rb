module Jim::System
	Jekyll::Hooks.register(:site, :after_init) { |site| Jim::System.init(site, Jekyll.logger) }
end if Module.const_defined?(:Jekyll)
