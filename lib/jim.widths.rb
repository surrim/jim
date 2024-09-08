# frozen_string_literal: true

class Jim
	attr_reader :widths

	DEFAULT_WIDTHS = []

	def widths(*widths)
		rm_widths
		widths.flatten.uniq.each { |width|
			add_width(width)
		}
		self
	end

	def add_width(width)
		unless @widths.include?(width&.to_i)
			@widths.push(width&.to_i)
			@widths.sort! { |a, b| (a || Float::INFINITY) <=> (b || Float::INFINITY) }
		end
		self
	end

	def rm_width(width)
		@widths.delete(width&.to_i)
		self
	end

	def rm_widths
		@widths = []
		self
	end

	module LiquidFilters
		def jim_widths(jim, *widths) = jim.widths(widths)
		def jim_add_width(jim, width) = jim.add_width(width)
		def jim_rm_width(jim, width) = jim.rm_width(width)
		def jim_rm_widths(jim) = jim.rm_widths
	end
end
