# frozen_string_literal: true

class Jim
  Dir[
    File.join(__dir__.to_s, 'jim', '*.rb'),
    File.join(__dir__.to_s, '*.rb')
  ].each { |file| require_relative file }
  include Validator

  include FallbackMixin
  include FilenamePatternsMixin
  include FormatSetupsMixin
  include FormatsMixin
  include ImgAttrsMixin
  include ImgSizesMixin
  include NewMixin
  include NomarkdownMixin
  include RenderMixin
  include StylesMixin
  include SubstitutionsMixin
  include TemplateMixin
  include WatermarkMixin
  include WidthsMixin

  Liquid::Template.register_filter(LiquidFilters)

  def to_preset
    Jim::Utils.deep_stringify_keys(self.class.preset_constants.map do |preset_constant|
      name = preset_constant[:name]
      value = instance_variable_get("@#{name}")
      [name, value]
    end.to_h)
  end

  def to_h = Jim::Utils.deep_merge(to_preset, { src: @src, alt: @alt })
  def to_s = to_h.to_s
  def to_liquid = self
  def to_json(opts = JSON::PRETTY_STATE_PROTOTYPE) = to_h.to_json(opts)
  def inspect = "#<#{self.class.name}:0x#{object_id.to_s(16)} @src=#{@src.inspect}, @alt=#{@alt.inspect}>"

  private

  class << self
    def preset_constants
      @preset_constants ||= constants.filter { |constant_name| constant_name.start_with?('DEFAULT_') }
                                     .map do |constant_name|
        constant_value = Jim::Utils.deep_stringify_keys(const_get(constant_name))
        name = constant_name['DEFAULT_'.length..].downcase.to_sym
        { constant_name:, constant_value:, name: }.freeze
      end.freeze
    end

    def hard_coded_preset
      @hard_coded_preset ||= Jim::Utils.deep_stringify_keys(preset_constants.map do |preset_constant|
        name = preset_constant[:name]
        constant_value = preset_constant[:constant_value]
        [name, constant_value]
      end.to_h)
    end
  end
end
