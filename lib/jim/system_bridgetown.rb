# frozen_string_literal: true

module Jim::System
	Bridgetown.initializer :jim do |_config| end
	Bridgetown::Hooks.register(:site, :after_init) { |site| Jim::System.init(site, Bridgetown.logger) }
end if Module.const_defined?(:Bridgetown)
