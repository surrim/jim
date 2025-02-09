# frozen_string_literal: true

class Jim
  Dir[
    File.join(__dir__.to_s, '*.rb'),
    File.join(__dir__.to_s, 'jim', '*.rb')
  ].each { |file| require_relative file }

  Liquid::Template.register_filter(LiquidFilters)

  def to_h
    h = { src: @src, alt: @alt }
    self.class.constants
        .filter { |constant| constant.start_with? 'DEFAULT_' }
        .each do |constant|
      name = constant[:DEFAULT_.length..].downcase
      value = instance_variable_get("@#{name}")
      h[name.to_sym] = value
    end
    h
  end

  def to_s = Jim::Utils.deep_stringify_keys(to_h).to_s
  def to_liquid = self
  def to_json(opts = JSON::PRETTY_STATE_PROTOTYPE) = to_h.to_json(opts)
end
