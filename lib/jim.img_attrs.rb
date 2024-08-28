class Jim
	attr_reader :img_attrs

	DEFAULT_IMG_ATTRS = {}

	def img_attrs(*img_attrs)
		rm_img_attrs()
		{}.merge(*img_attrs.flatten.compact).each do |key, value|
			add_img_attr(key, value)
		end
		self
	end

	def add_img_attr(key, value)
		@img_attrs[key.to_sym] = value.to_s \
			if Validator.check_is_symbol(key, :key)
		self
	end

	def rm_img_attr(key)
		@img_attrs.delete(key.to_sym)
		self
	end

	def rm_img_attrs()
		@img_attrs = {}
		self
	end

	module LiquidFilters
		def jim_img_attrs(jim, *img_attrs) = jim.img_attrs(img_attrs)
		def jim_add_img_attr(jim, key, value) = jim.add_img_attr(key, value)
		def jim_rm_img_attr(jim, key) = jim.rm_img_attr(key)
		def jim_rm_img_attrs(jim) = jim.rm_img_attrs()
	end
end
