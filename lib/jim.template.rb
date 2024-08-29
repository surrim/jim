class Jim
	attr_reader :template

	DEFAULT_TEMPLATE = "jim-template.html".freeze

	def template(template)
		@template = template.nil? ? DEFAULT_TEMPLATE : template.to_s
		self
	end

	def reset_template() = template(nil)

	module LiquidFilters
		def jim_template(jim, template) = jim.template(template)
		def jim_reset_template(jim) = jim.reset_template()
	end
end
